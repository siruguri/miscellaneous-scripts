require 'pry'

module TextStats
  class DotProduct
    # Currently, only running dot-product for 1-grams

    attr_reader :score, :products, :dot_product
    def initialize(d1, d2, opts = {})
      @source_names=[d1.source_name, d2.source_name]
      @products = {}
      common_keys = d1.terms & d2.terms

      @intersection_size = common_keys.size
      @dot_product = common_keys.inject(0) do |memo, k|
        @products[k] = d1.counts[k] * d2.counts[k].to_f

        if opts[:universe]
          @products[k] /= opts[:universe].universe_count(k)
        end
        
        memo += @products[k]
      end

      @score = @dot_product / ((@_d1m=d1.magnitude) * (@_d2m=d2.magnitude))
    end

    def explanation(opts = {})
      expl = @products.sort_by do |k, v|
        if opts[:universe]
          v /= opts[:universe].universe_count(k)
        end
        -1 * v
      end.map do |k, v|
        if opts[:universe]
          v /= opts[:universe].universe_count(k)
          k += " (#{opts[:universe].universe_count(k)})"
        end
        
        score = v.to_f/@_d2m/@_d1m
        "#{k}:#{score}"
      end.join("\n")

      expl += "\nIntersection size: #{@intersection_size}"
    end
  end
  
  class DocumentModel
    attr_reader :term_list, :body, :source_name, :document_length
    attr_accessor :universe
    
    def initialize(body, opts={})
      if File.exists? body
        @body = File.open(body, 'r').readlines.join(' ').gsub /’/, '\''
        @source_name = body
      else
        @body = body
        @source_name = 'anon'
      end

      @term_list = self.word_array opts
      @document_length = @term_list.size.to_f
      @tf = {}
      @counts = {}
    end

    def terms(term_size=1)
      counts(term_size).keys
    end
    
    def tfs(term_size=1)
      counts(term_size) if @counts[term_size].nil?

      unless @tf[term_size]
        generate_frequencies(term_size)
      end

      @tf[term_size]
    end

    def word_array(opts = {})
      if opts[:as_html]
        @body.gsub!(/<\/?[^>]+>/, ' ')
      end
      ((@body.gsub(/[^'a-zA-Z0-9]/, ' ').strip.split(/\s+/).map(&:downcase)) - stop_words).slice(0..300)
    end

    def counts(term_size = 1, opts = {})
      if term_size > 1
        @counts[1] ||= counts
      end
      @counts["#{term_size}.#{opts[:unigram_boost]}"] ||=
        ngramify(term_size).group_by { |word| word }.
        inject({}) do |memo, pair|
        multiplier = (if opts[:unigram_boost].nil?
                      1
                     else
                       terms = pair[0].split /\s+/
                       terms.inject(1) { |memo, term| memo * Math.log(@counts[1][term]) }
                      end)
        memo[pair[0]] = pair[1].size * multiplier
        memo
      end
    end

    def sorted_counts(term_size = 1, opts = {})
      counts(term_size, opts).sort_by { |k, v| v}
    end
    
    def cosine_sim(vec)
      DotProduct.new(self, vec, universe: @universe)
    end

    def magnitude(term_size=1)
      sqr_mag = counts(term_size).inject(0) do |memo, h|
        prod = h[1] * h[1]
        if @universe
          prod /= (@universe.universe_count(h[0]) * @universe.universe_count(h[0]))
        end
        
        memo += prod
      end

      Math.sqrt(sqr_mag)
    end

    private
    def generate_frequencies(term_size)
      @tf[term_size] = @counts[term_size].keys.inject({}) do |memo, k|
        memo[k] = @counts[term_size][k]
        memo
      end
    end

    def ngramify(term_size)
      # Convert term list into array of ordered n grams
      # 1gram means the term list itself

      if term_size == 1
        return @term_list
      end

      (0..@term_list.size - term_size).map do |index|
        (0..term_size - 1).map { |rep| @term_list[index+rep] }.join ' '
      end
    end

    def raw_count_score(a, b)
      b[:count] <=> a[:count]
    end

    def boosted_count_score(a, b)
      words_a = a[:value].split(' ')
      words_b = b[:value].split(' ')

      ct1 = a[:count] * @gram_counts[words_a[0]] * @gram_counts[words_a[1]]
      ct2 = b[:count] * @gram_counts[words_b[0]] * @gram_counts[words_b[1]]

      ct2 <=> ct1
    end

    def stop_words
      @stop_words ||=
        %w(' a able it's about above abst accordance according accordingly across act actually added adj affected affecting affects after afterwards again against ah all almost alone along already also although always am among amongst an and announce another any anybody anyhow anymore anyone anything anyway anyways anywhere apparently approximately are aren arent arise around as aside ask asking at auth available away awfully b back be became because become becomes becoming been before beforehand begin beginning beginnings begins behind being believe below beside besides between beyond biol both brief briefly but by c ca came can cannot can't cause causes certain certainly co com come comes contain containing contains could couldnt d date did didn't different do does doesn't doing done don't down downwards due during e each ed edu effect eg eight eighty either else elsewhere end ending enough especially et et-al etc even ever every everybody everyone everything everywhere ex except f far few ff fifth first five fix followed following follows for former formerly forth found four from further furthermore g gave get gets getting give given gives giving go goes gone got gotten h had happens hardly has hasn't have haven't having he hed hence her here hereafter hereby herein heres hereupon hers herself hes hi hid him himself his hither home how howbeit however hundred i id ie if i'll im immediate immediately importance important in inc indeed index information instead into invention inward is isn't it itd it'll its itself i've j just k keep keeps kept kg km know known knows l largely last lately later latter latterly least less lest let lets like liked likely line little ll look looking looks ltd m made mainly make makes many may maybe me mean means meantime meanwhile merely mg might million miss ml more moreover most mostly mr mrs much mug must my myself n na name namely nay nd near nearly necessarily necessary need needs neither never nevertheless new next nine ninety no nobody non none nonetheless noone nor normally nos not noted nothing now nowhere o obtain obtained obviously of off often oh ok okay old omitted on once one ones only onto or ord other others otherwise ought our ours ourselves out outside over overall owing own p page pages part particular particularly past per perhaps placed please plus poorly possible possibly potentially pp predominantly present previously primarily probably promptly proud provides put q que quickly quite qv r ran rather rd re readily really recent recently ref refs regarding regardless regards related relatively research respectively resulted resulting results right run s said same saw say saying says sec section see seeing seem seemed seeming seems seen self selves sent seven several shall she shed she'll shes should shouldn't show showed shown showns shows significant significantly similar similarly since six slightly so some somebody somehow someone somethan something sometime sometimes somewhat somewhere soon sorry specifically specified specify specifying still stop strongly sub substantially successfully such sufficiently suggest sup sure than that that's the their theirs them themselves then there there's these they they'd they'll they're they've this those through to too u under until up very was wasn't we we'd we'll we're we've were weren't what what's when when's where where's which while who who's whom why why's will with won't would wouldn't x you you'd you'll you're you've your yours yourself yourselves)
    end
  end

  class DocumentUniverse
    def initialize
      @_counts = {}
      @_univ_size = 0
    end

    def add(doc_model)
      @_univ_size += 1
      doc_model.terms.each do |k|
        @_counts[k] ||= 0
        @_counts[k] += 1
      end
    end

    def universe_count(term)
      if @_counts[term]
        @_counts[term]
      else
        1
      end
    end
  end
end
