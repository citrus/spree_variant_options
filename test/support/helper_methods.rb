module HelperMethods
  
  # Checks for missing translations after each test
  def teardown
    unless source.blank?
      matches = source.match(/translation[\s-]+missing[^"]*/) || []
      assert_equal 0, matches.length, "Translation Missing! - #{matches[0]}"
    end
  end
  
  # An assertion for ensuring content has made it to the page.
  #    
  #    assert_seen "Site Title"
  #    assert_seen "Peanut Butter Jelly Time", :within => ".post-title h1"
  #      
  def assert_seen(text, opts={})
    if opts[:within]
      within(opts[:within]) do
        assert has_content?(text)
      end
    else
      assert has_content?(text)
    end
  end
  
end
