require 'minitest/autorun'
require_relative 'text_stats'

class TextStatsTest < Minitest::Test
  def setup
    @model_1 = TextStats::DocumentModel.new 'cat dog cat cat cat dog buffalo'
    @model_2 = TextStats::DocumentModel.new 'cat dog cat cat cat dog buffalo'
    @model_3 = TextStats::DocumentModel.new 'cat dog cat cat cat'
  end

  def test_counting_works
    assert_equal({"cat" => 4, "dog" => 2, "buffalo" => 1}, @model_1.counts)
    assert_equal({"cat dog" => 2, "dog cat" => 1, "cat cat"=>2, "dog buffalo" => 1}, @model_1.counts(2))
  end
  def test_sorted_counting_works
    assert_equal([["buffalo", 1], ["dog", 2], ["cat", 4]], @model_1.sorted_counts)
  end
  def test_sorted_counting_works_with_boosting
    refute_equal @model_1.sorted_counts(2, unigram_boost: 1), @model_1.sorted_counts(2)

    assert_equal [["dog buffalo", 0.0], ["dog cat", 0.9609060278364028], ["cat dog", 1.9218120556728056], ["cat cat", 3.843624111345611]],
                 @model_1.sorted_counts(2, unigram_boost: 1)
  end
  def test_cosine_sim
    assert_equal "1", sprintf("%.25g", @model_1.cosine_sim(@model_2).score)
  end

  def test_universe
    d = TextStats::DocumentUniverse.new
    d.add @model_1
    d.add @model_2
    d.add @model_3
    
    assert_equal 3, d.universe_count('cat')
    assert_equal 2, d.universe_count('buffalo')
  end
end
