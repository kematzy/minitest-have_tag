require 'minitest'
require 'minitest/have_tag/version'

module Minitest::Assertions
  require 'nokogiri'
  
  # Method to test for existence of HTML tag, including contents, within the provided string.
  # 
  #     assert_have_tag('<br>', 'br')  #=> 
  #     
  #     # check for CSS :class attribute
  #     assert_have_tag('<hr class="divider">', 'hr.divider')
  #     assert_have_tag('<hr class="divider">', 'hr[@class=divider]')
  #     
  #     # check for CSS :id attribute
  #     assert_have_tag('<hr id="divider">', 'hr#divider')
  #     assert_have_tag('<hr id="divider">', 'hr[@id=divider]')
  #     
  #     # check for contents within a <div...>
  #     assert_have_tag('<div class="row">contents</div>', 'hr.row', 'contents')
  #     
  #     html = <<-HTML
  #       <div id="intro" class="row">
  #         <div class="col-md-12">
  #           <h1>Header</h1>
  #         </div>
  #       </div>
  #     HTML
  #     # 
  #     assert_have_tag(html, 'div#intro.row > .col-md-12 > h1', 'Header')
  #     
  #     
  #     Produces an extensive error message when something is wrong
  #     
  #     assert_have_tag('<br>', 'brr')
  #       #=> 'Expected "<br>" to have tag ["brr"], but no such tag was found'
  #     
  #
  def assert_have_tag(actual, expected, contents = nil, msg = nil)
    msg = msg.nil? ? '' : "#{msg}\n"
    msg << "Expected #{actual.inspect} to have tag [#{expected.inspect}]"
    
    doc = Nokogiri::HTML(actual)
    res  = doc.css(expected)
    
    if res.empty?
      msg << ', but no such tag was found'
      matching = false
    else
      # such a tag was found
      matching = true
      
      if contents
        if contents.is_a?(String)
          unless res.any? { |tag| tag.inner_html == contents }
            matching = false
            msg << " with contents [#{contents.inspect}], but the tags content found is [#{res.map(&:inner_html).join(', ')}]"
          end
        elsif contents.is_a?(Regexp)
          if res.inner_html =~ contents
            matching = true
          else
            msg << " with inner_html [#{res.inner_html}],"
            msg << " but did not match Regexp [#{contents.inspect}]"
            matching = false
          end
        else
          msg << ", ERROR: contents is neither String nor Regexp, it's [#{contents.class}]"
          matching = false
        end
      else
        # no contents given, so ignore
      end
    end
    assert matching, msg
  end
  
  # Method to test for non-existence of the expected HTML tag, including contents, 
  # within the provided string.
  # 
  #     refute_have_tag('<abbr>', 'br')  #=> 
  #     
  #     # check for CSS :class attribute
  #     refute_have_tag('<hr class="divider">', 'hr.space')
  #     refute_have_tag('<hr class="divider">', 'hr[@class=space]')
  #     
  #     # check for CSS :id attribute
  #     refute_have_tag('<hr id="divider">', 'hr#space')
  #     refute_have_tag('<hr id="divider">', 'hr[@id=space]')
  #     
  #     # check for contents within a <div...>
  #     refute_have_tag('<div class="row">contents</div>', 'hr.row', '<h1>Header</h1>')
  #     
  #     html = <<-HTML
  #       <div id="intro" class="row">
  #         <div class="col-md-12">
  #           <h1>Header</h1>
  #         </div>
  #       </div>
  #     HTML
  #     # 
  #     refute_have_tag(html, 'div#intro.row > .col-md-12 > h1', 'Header')
  #     
  #     
  #     Produces an extensive error message when something is wrong
  #     
  #     refute_have_tag('<br>', 'br')
  #       #=> 'Expected "<br>" to NOT have tag ["br"], but such a tag was found'
  #     
  #
  def refute_have_tag(actual, expected, contents = nil, msg = nil)
    msg = msg.nil? ? '' : "#{msg}\n"
    msg << "Expected #{actual.inspect} to NOT have tag [#{expected.inspect}]"
    
    doc = Nokogiri::HTML(actual)
    res  = doc.css(expected)
    
    # if res has something within it that means we have mostly a match, 
    # so now we need to check contents
    unless res.empty?
      msg << ', but such a tag was found'
      matching = true
      
      if contents
        if contents.is_a?(String)
          if res.inner_html == contents
            matching = true
          else
            msg << " with contents [#{contents.inspect}], but the tag content is [#{res.inner_html}]"
            matching = false
          end
        elsif contents.is_a?(Regexp)
          if res.inner_html =~ contents
            matching = true
          else
            msg << " with inner_html [#{res.inner_html}],"
            msg << " but did not match Regexp [#{contents.inspect}]"
            matching = false
          end
        else
          msg << ", ERROR: contents is neither String nor Regexp, it's [#{contents.class}]"
          matching = false
        end
      else
        # no contents given, so ignore
      end
      
    else
      # such a tag was found, BAD
      matching = false
    end
    refute matching, msg
  end
  
end

# add support for Spec syntax
module Minitest::Expectations
  infect_an_assertion :assert_have_tag, :must_have_tag, :reverse
  infect_an_assertion :refute_have_tag, :wont_have_tag, :reverse
end
