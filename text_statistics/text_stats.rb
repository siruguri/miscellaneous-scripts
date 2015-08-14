module TextStats
  class DocumentModel
    attr_reader :term_list, :body

    def initialize(body, opts={})
      @body = body
      @term_list = self.word_array opts
      @document_length = @term_list.size.to_f
      @tf = {}
      @counts = {}
    end

    def terms(term_size=1)
      unless @tf[term_size]
        run_stats(term_size)
      end

      @tf[term_size].keys
    end
    
    def tfs(term_size=1)
      unless @tf[term_size]
        run_stats(term_size)
      end

      @tf[term_size]
    end

    def word_array(opts = {})
      if opts[:as_html]
        @body.gsub!(/<\/?[^>]+>/, ' ')
      end
      @body.gsub(/[^'a-zA-Z0-9]/, ' ').split(/\s+/).map(&:downcase).select { |w| !stop_words.include?(w) }
    end

    def run_stats(term_size = 1)
      @counts[term_size] ||= counts(term_size)

      @tf[term_size] = @counts[term_size].keys.inject({}) do |memo, k|
        memo[k] = @counts[term_size][k] / @document_length
        memo
      end
    end

    def counts(term_size = 1)
      unless @counts[term_size]
        @counts[term_size] = {}
        @term_list.each do |word|
          @counts[term_size][word] ||= 0
          @counts[term_size][word] += 1
        end
      end
      @counts[term_size]
    end
    
    def cosine_sim(vec, universe=nil)
      @_universe ||= universe
      dot_product(vec)/(magnitude * vec.magnitude)
    end

    def explanation(vec, universe=nil)
      @_universe ||= universe
      common_keys = self.terms & vec.terms
      
      (common_keys.map do |k|
         if @_universe.nil?
           [k, self.tfs[k] * vec.tfs[k]]
         else
           [k, self.tfs[k] * vec.tfs[k] * @_universe.idf(k) * @_universe.idf(k)]
         end
       end).sort { |a, b| b[1] <=> a[1]}.slice(0..5).map do |t|

        "#{t[0]}:#{(t[1]*100000).to_i}"
      end.join("\t")
    end
    
    def top_bigrams(sort_by_function_name, opts = {})
      @gram_counts = {}
      @bigram_counts = {}

      max_words = (opts[:max] || 5) - 1
      
      all_words = word_array
      # Use a hash to count the occurrences of bigrams

      all_words.each_with_index do |word, idx|
        if !stop_words.include?(word)
          @gram_counts[word] ||= 0
          @gram_counts[word] += 1

          if idx < all_words.size - 1 and 
            !stop_words.include?(all_words[idx+1])
            if (key="#{word} #{all_words[idx+1]}").length > 8
              @bigram_counts[key] ||= 0
              @bigram_counts[key] += 1
            end
          end
        end
      end

      resp = []
      x=(@bigram_counts.inject([]) do |memo, item|
           # convert the counts hash to an array
           memo << {value: item[0], count: item[1]}
         end.sort do |a, b|
           # Sort the array by the counts of each bigram, desc
           case sort_by_function_name
           when 'raw' then raw_count_score(a, b)
           when 'unigram_boosted' then boosted_count_score(a, b)
           end
         end)

      x[0..([max_words, x.size-1].max)].each_with_index do |item, idx|
        # Keep the top N.
        resp << ({id: idx, name: item[:value]})
      end

      resp
    end

    def magnitude(term_size=1)
      sqr_mag = tfs.inject(0) do |memo, h|
        prod = h[1] * h[1]
        if @_universe
          prod *= (@_universe.idf(h[0]) * @_universe.idf(h[0]))
        end
        
        memo += prod
      end

      Math.sqrt(sqr_mag)
    end

    private
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
        %w(a able it's about above abst accordance according accordingly across act actually added adj affected affecting affects after afterwards again against ah all almost alone along already also although always am among amongst an and announce another any anybody anyhow anymore anyone anything anyway anyways anywhere apparently approximately are aren arent arise around as aside ask asking at auth available away awfully b back be became because become becomes becoming been before beforehand begin beginning beginnings begins behind being believe below beside besides between beyond biol both brief briefly but by c ca came can cannot can't cause causes certain certainly co com come comes contain containing contains could couldnt d date did didn't different do does doesn't doing done don't down downwards due during e each ed edu effect eg eight eighty either else elsewhere end ending enough especially et et-al etc even ever every everybody everyone everything everywhere ex except f far few ff fifth first five fix followed following follows for former formerly forth found four from further furthermore g gave get gets getting give given gives giving go goes gone got gotten h had happens hardly has hasn't have haven't having he hed hence her here hereafter hereby herein heres hereupon hers herself hes hi hid him himself his hither home how howbeit however hundred i id ie if i'll im immediate immediately importance important in inc indeed index information instead into invention inward is isn't it itd it'll its itself i've j just k keep keeps kept kg km know known knows l largely last lately later latter latterly least less lest let lets like liked likely line little ll look looking looks ltd m made mainly make makes many may maybe me mean means meantime meanwhile merely mg might million miss ml more moreover most mostly mr mrs much mug must my myself n na name namely nay nd near nearly necessarily necessary need needs neither never nevertheless new next nine ninety no nobody non none nonetheless noone nor normally nos not noted nothing now nowhere o obtain obtained obviously of off often oh ok okay old omitted on once one ones only onto or ord other others otherwise ought our ours ourselves out outside over overall owing own p page pages part particular particularly past per perhaps placed please plus poorly possible possibly potentially pp predominantly present previously primarily probably promptly proud provides put q que quickly quite qv r ran rather rd re readily really recent recently ref refs regarding regardless regards related relatively research respectively resulted resulting results right run s said same saw say saying says sec section see seeing seem seemed seeming seems seen self selves sent seven several shall she shed she'll shes should shouldn't show showed shown showns shows significant significantly similar similarly since six slightly so some somebody somehow someone somethan something sometime sometimes somewhat somewhere soon sorry specifically specified specify specifying still stop strongly sub substantially successfully such sufficiently suggest sup sure than that that's the their theirs them themselves then there there's these they they'd they'll they're they've this those through to too under until up very was wasn't we we'd we'll we're we've were weren't what what's when when's where where's which while who who's whom why why's with won't would wouldn't x you you'd you'll you're you've your yours yourself yourselves)
    end

    def dot_product(vec)
      common_keys = self.terms & vec.terms
      
      dot_product = common_keys.inject(0) do |memo, k|
        prod = self.tfs[k] * vec.tfs[k]

        if @_universe
          prod *= (@_universe.idf(k) * @_universe.idf(k))
        end
        memo += prod
      end
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

    def idf(term)
      if @_counts[term]
        ret = @_univ_size / @_counts[term].to_f
      else
        1/0
      end

      ret
    end
  end
end
