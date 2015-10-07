require 'minitest/autorun'
require_relative 'text_stats'

class TextStatsTest < Minitest::Test
  def setup
    @model = TextStats::DocumentModel.new 'cat dog cat cat cat dog buffalo'
  end

  def test_counting_works
    assert_equal({"cat" => 4, "dog" => 2, "buffalo" => 1}, @model.counts)
    assert_equal({"cat dog" => 2, "dog cat" => 1, "cat cat"=>2, "dog buffalo" => 1}, @model.counts(2))
  end
  def test_sorted_counting_works
    assert_equal([["buffalo", 1], ["dog", 2], ["cat", 4]], @model.sorted_counts)
  end
  def test_sorted_counting_works_with_boosting
    refute_equal @model.sorted_counts(2, unigram_boost: 1), @model.sorted_counts(2)

    assert_equal [["dog buffalo", 0.0], ["dog cat", 0.9609060278364028], ["cat dog", 1.9218120556728056], ["cat cat", 3.843624111345611]],
                 @model.sorted_counts(2, unigram_boost: 1)
  end
end

  
