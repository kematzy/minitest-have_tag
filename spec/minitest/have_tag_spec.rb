require_relative '../spec_helper'

describe Minitest::HaveTag do
  
  it 'has a version number' do
    Minitest::HaveTag::VERSION.wont_be_nil
    Minitest::HaveTag::VERSION.must_match %r{^\d+\.\d+\.\d+$}
  end
  
end

describe Minitest::Spec do
  
  describe '#assert_have_tag & #refute_have_tag' do
    
    it "should handle nil tag" do
      assert_returns_error('Expected nil to have tag ["br"], but no such tag was found') do 
        assert_have_tag(nil, 'br')
      end
      # ===
      assert_no_error { refute_have_tag(nil, 'br') }
    end
    
    it 'should handle empty "" tag' do
      assert_returns_error('Expected "" to have tag ["br"], but no such tag was found') do 
        assert_have_tag('', 'br')
      end
      # ===
      assert_no_error { refute_have_tag('', 'br') }
    end
    
    it "should handle a basic <br> tag" do
      assert_no_error { assert_have_tag("<br>", 'br') }
      # ===
      assert_returns_error(%Q{Expected \"<br>\" to NOT have tag [\"br\"], but such a tag was found}) do 
        refute_have_tag('<br>', 'br')
      end
    end
    
    it 'should handle an incorrectly expected tag' do
      assert_returns_error('Expected "<br>" to have tag ["brr"], but no such tag was found') do 
        assert_have_tag("<br>", 'brr')
      end
      # ===
      assert_no_error { refute_have_tag('<br>', 'brr') }
    end
    
    it 'should handle a basic <hr class="..."> tag with a class attribute' do
      assert_no_error { assert_have_tag('<hr class="divider">', 'hr[class]') }
      # ===
      assert_returns_error(%Q{Expected "<hr class=\\"divider\\">" to NOT have tag ["hr[class]"], but such a tag was found}) do 
        refute_have_tag('<hr class="divider">', 'hr[class]')
      end
    end
    
    it "should handle an basic <hr class=""> tag with a class attribute with an incorrectly expected attribute" do
      assert_returns_error('Expected "<hr class=\"divider\">" to have tag ["hr[classs]"], but no such tag was found') do 
        assert_have_tag('<hr class="divider">', 'hr[classs]')
      end
      #===
      assert_no_error { refute_have_tag('<hr class="divider">', 'hr[classs]') }
    end
    
    it 'should handle a basic tag with a class attribute' do
      assert_no_error { assert_have_tag('<hr class="divider">', 'hr[class=divider]') }
      # ===
      assert_returns_error('Expected "<hr class=\\"divider\\">" to NOT have tag ["hr[class=divider]"], but such a tag was found') do 
        refute_have_tag('<hr class="divider">', 'hr[class=divider]')
      end
    end
    
    it 'should handle an basic tag with a class attribute with an incorrectly expected attribute' do
      assert_returns_error('Expected "<hr class=\"divider\">" to have tag ["hr[class=divder]"], but no such tag was found') do 
        assert_have_tag('<hr class="divider">', 'hr[class=divder]')
      end
      # ===
      assert_no_error { refute_have_tag('<hr class="divider">', 'hr[class=divder]') }
    end
    
    it 'should handle a basic <div...> tag with id and class attributes' do
      assert_no_error { assert_have_tag(%Q{<div id="header" class="row"></div>}, 'div#header') }
      # ===
      assert_returns_error(%Q{Expected "<div id=\\"header\\" class=\\"row\\"></div>" to NOT have tag ["div#header"], but such a tag was found}) do
        refute_have_tag(%Q{<div id="header" class="row"></div>}, 'div#header')
      end
      
      assert_no_error { assert_have_tag(%Q{<div id="header" class="row"></div>}, 'div[id=header]') }
      # ===
      assert_returns_error(%Q{Expected "<div id=\\"header\\" class=\\"row\\"></div>" to NOT have tag ["div[id=header]"], but such a tag was found}) do
        refute_have_tag(%Q{<div id="header" class="row"></div>}, 'div[id=header]')
      end
      
      assert_no_error { assert_have_tag(%Q{<div id="header" class="row"></div>}, 'div.row') }
      # ===
      assert_returns_error(%Q{Expected "<div id=\\"header\\" class=\\"row\\"></div>" to NOT have tag ["div.row"], but such a tag was found}) do
        refute_have_tag(%Q{<div id="header" class="row"></div>}, 'div.row')
      end
      
      assert_no_error { assert_have_tag(%Q{<div id="header" class="row"></div>}, 'div[class=row]') }
      # ===
      assert_returns_error('Expected "<div id=\\"header\\" class=\\"row\\"></div>" to NOT have tag ["div[class=row]"], but such a tag was found') do
        refute_have_tag(%Q{<div id="header" class="row"></div>}, 'div[class=row]')
      end
      
      assert_no_error { assert_have_tag(%Q{<div id="header" class="row"></div>}, 'div#header.row') }
      # ===
      assert_returns_error('Expected "<div id=\\"header\\" class=\\"row\\"></div>" to NOT have tag ["div#header.row"], but such a tag was found') do
        refute_have_tag(%Q{<div id="header" class="row"></div>}, 'div#header.row')
      end
      
      assert_no_error { assert_have_tag(%Q{<div id="header" class="row"></div>}, 'div[id=header][class=row]') }
      # ===
      assert_returns_error('Expected "<div id=\\"header\\" class=\\"row\\"></div>" to NOT have tag ["div[id=header][class=row]"], but such a tag was found') do
        refute_have_tag(%Q{<div id="header" class="row"></div>}, 'div[id=header][class=row]')
      end
      
      assert_no_error { assert_have_tag(%Q{<div id="header" class="row columns"></div>}, 'div[class=\'row columns\']') }
      # ===
      assert_returns_error('Expected "<div id=\\"header\\" class=\\"row columns\\"></div>" to NOT have tag ["div[class=\'row columns\']"], but such a tag was found') do
        refute_have_tag(%Q{<div id="header" class="row columns"></div>}, 'div[class=\'row columns\']')
      end
      
    end
    
    it 'should handle an basic <div...> tag with id and class attributes with an incorrectly expected attribute' do
      assert_returns_error(%Q{Expected "<div id=\\"header\\" class=\\"row\\"></div>" to have tag ["div#headers"], but no such tag was found}) do 
        assert_have_tag(%Q{<div id="header" class="row"></div>}, 'div#headers')
      end
      # ===
      assert_no_error { refute_have_tag(%Q{<div id="header" class="row"></div>}, 'div#headers') }
      
      # ----
      
      assert_returns_error(%Q{Expected "<div id=\\"header\\" class=\\"row\\"></div>" to have tag ["div#header.rows"], but no such tag was found}) do 
        assert_have_tag(%Q{<div id="header" class="row"></div>}, 'div#header.rows')
      end
      # ===
      assert_no_error { refute_have_tag(%Q{<div id="header" class="row"></div>}, 'div#header.rows') }
    end
    
    it 'should handle a basic <label...> tag with for attribute and nil contents' do
      assert_no_error { assert_have_tag(%Q{<label for="name">Name:</label>\n}, 'label[for=name]', nil) }
      # ===
      assert_returns_error(/to NOT have tag \["label\[for=name\]"\], but such a tag was found/) do 
        refute_have_tag(%Q{<label for="name">Name:</label>}, 'label[for=name]', nil) 
      end
    end
    
    it 'should handle a basic <label...> tag with for attribute and empty contents' do
      assert_no_error { assert_have_tag(%Q{<label for="name"></label>}, 'label[for=name]', '') }
      
      assert_returns_error('Expected "<label for=\\"name\\">contents</label>" to have tag ["label[for=name]"] with contents [""], but the tag content is [contents]') do
        assert_have_tag(%Q{<label for="name">contents</label>}, 'label[for=name]', '')
      end
      # ===
      assert_returns_error(/to NOT have tag \["label\[for=name\]"\], but such a tag was found/) do 
        refute_have_tag(%Q{<label for="name"></label>\n}, 'label[for=name]', '') 
      end
      assert_no_error { refute_have_tag(%Q{<label for="name">contents</label>\n}, 'label[for=name]', '') }
    end
    
    it 'should handle a basic <label...> tag with for attribute and symbol contents' do
      assert_returns_error(/ERROR: contents is neither String nor Regexp, it's \[Symbol\]/) do
        assert_have_tag(%Q{<label for="name"></label>\n}, 'label[for=name]', :symbol)
      end
      # ===
      assert_no_error { refute_have_tag(%Q{<label for="name"></label>\n}, 'label[for=name]', :symbol) }
    end
    
    it 'should handle a basic <label...> tag with inner_html and empty contents' do
      e = "Expected \"<label for=\\\"name\\\">Username:</label>\" to have tag [\"label[for=name]\"]"
      e << " with contents [\"\"], but the tag content is [Username:]"
      assert_returns_error(e) do
        assert_have_tag(%Q{<label for="name">Username:</label>}, 'label[for=name]', '')
      end
      # ===
      assert_no_error { refute_have_tag(%Q{<label for="name">Username:</label>}, 'label[for=name]', '') }
    end
    
    it 'should handle a basic <label...> tag with for attribute and contents' do
      assert_no_error { assert_have_tag(%Q{<label for="name">Name:</label>\n}, 'label[for=name]', 'Name:') }
      # ===
      assert_returns_error("Expected \"<label for=\\\"name\\\">Name:</label>\" to NOT have tag [\"label[for=name]\"], but such a tag was found") do
        refute_have_tag(%Q{<label for="name">Name:</label>}, 'label[for=name]', 'Name:')
      end
      # ---
      
      assert_no_error { assert_have_tag(%Q{<label for="name">User Name:</label>\n}, 'label[for=name]', 'User Name:') }
      # ===
      assert_returns_error('Expected "<label for=\\"name\\">User Name:</label>" to NOT have tag ["label[for=name]"], but such a tag was found') do
        refute_have_tag(%Q{<label for="name">User Name:</label>}, 'label[for=name]', 'User Name:')
      end
      
    end
    
    it "should handle a basic <label...> tag with for attribute and contents with incorrect expectations" do
      assert_no_error { assert_have_tag(%Q{<label for="name">Name:</label>\n}, 'label[for=name]', 'Name:') }
      # ===
      assert_returns_error('Expected "<label for=\\"name\\">Name:</label>" to NOT have tag ["label[for=name]"], but such a tag was found') do
        refute_have_tag(%Q{<label for="name">Name:</label>}, 'label[for=name]', 'Name:')
      end
    end
    
    it 'should handle a basic <label...> tag with for attribute and Regexp contents' do
      assert_no_error { assert_have_tag(%Q{<label for="name">Username:</label>\n}, 'label[for=name]', /User/) }
      # ===
      assert_returns_error('Expected "<label for=\\"name\\">Username:</label>" to NOT have tag ["label[for=name]"], but such a tag was found') do
        refute_have_tag(%Q{<label for="name">Username:</label>}, 'label[for=name]', /User/)
      end
      
      # ----
      
      assert_no_error { assert_have_tag(%Q{<label for="name">User Name:</label>\n}, 'label[for=name]', /user/i) }
      # ===
      assert_returns_error('Expected "<label for=\\"name\\">User Name:</label>" to NOT have tag ["label[for=name]"], but such a tag was found') do
        refute_have_tag(%Q{<label for="name">User Name:</label>}, 'label[for=name]', /user/i)
      end
    end
    
    it 'should handle a basic <label...> tag with for attribute and Regexp contents' do
      e = "Expected \"<label for=\\\"name\\\">Username:</label>\" to have tag [\"label[for=name]\"]"
      e << " with inner_html [Username:], but did not match Regexp [/Users/]"
      
      assert_returns_error(e) do
        assert_have_tag(%Q{<label for="name">Username:</label>}, 'label[for=name]', /Users/)
      end
      # ===
      assert_no_error { refute_have_tag(%Q{<label for="name">Username:</label>}, 'label[for=name]', /Users/) }
      
      # ----
      
      assert_returns_error(e.sub('Regexp [/Users/]', 'Regexp [/users/i]')) do
        assert_have_tag(%Q{<label for="name">Username:</label>}, 'label[for=name]', /users/i)
      end
      # ===
      assert_no_error { refute_have_tag(%Q{<label for="name">Username:</label>}, 'label[for=name]', /users/i) }
      
    end
    
  end
  
  
  describe '#.must_have_tag & #.wont_have_tag' do
    
    it "should handle nil tag" do
      assert_returns_error('Expected nil to have tag ["br"], but no such tag was found') do 
        nil.must_have_tag('br')
      end
      # ===
      assert_no_error { nil.wont_have_tag('br') }
    end
    
    it 'should handle empty "" tag' do
      assert_returns_error('Expected "" to have tag ["br"], but no such tag was found') do 
        ''.must_have_tag('br')
      end
      # ===
      assert_no_error { ''.wont_have_tag('br') }
    end
    
    it "should handle a basic <br> tag" do
      assert_no_error { '<br>'.must_have_tag('br') }
      # ===
      assert_returns_error(%Q{Expected \"<br>\" to NOT have tag [\"br\"], but such a tag was found}) do 
        '<br>'.wont_have_tag('br')
      end
    end
    
    it 'should handle an incorrectly expected tag' do
      assert_returns_error('Expected "<br>" to have tag ["brr"], but no such tag was found') do 
        '<br>'.must_have_tag('brr')
      end
      # ===
      assert_no_error { '<br>'.wont_have_tag('brr') }
    end
    
    it 'should handle a basic <hr class="..."> tag with a class attribute' do
      assert_no_error { '<hr class="divider">'.must_have_tag('hr[class]') }
      # ===
      assert_returns_error(%Q{Expected "<hr class=\\"divider\\">" to NOT have tag ["hr[class]"], but such a tag was found}) do 
        '<hr class="divider">'.wont_have_tag('hr[class]')
      end
    end
    
    it "should handle an basic <hr class=""> tag with a class attribute with an incorrectly expected attribute" do
      assert_returns_error('Expected "<hr class=\"divider\">" to have tag ["hr[classs]"], but no such tag was found') do 
        '<hr class="divider">'.must_have_tag('hr[classs]')
      end
      #===
      assert_no_error { '<hr class="divider">'.wont_have_tag('hr[classs]') }
    end
    
    it 'should handle a basic <hr...> tag with a class attribute' do
      assert_no_error { '<hr class="divider">'.must_have_tag('hr[class=divider]') }
      # ===
      assert_returns_error('Expected "<hr class=\\"divider\\">" to NOT have tag ["hr[class=divider]"], but such a tag was found') do 
        '<hr class="divider">'.wont_have_tag('hr[class=divider]')
      end
    end
    
    it 'should handle an basic <hr...> tag with a class attribute with an incorrectly expected attribute' do
      assert_returns_error('Expected "<hr class=\"divider\">" to have tag ["hr[class=divder]"], but no such tag was found') do 
        '<hr class="divider">'.must_have_tag('hr[class=divder]')
      end
      # ===
      assert_no_error { '<hr class="divider">'.wont_have_tag('hr[class=divder]') }
    end
    
    it 'should handle a basic <div...> tag with id and class attributes' do
      assert_no_error { %Q{<div id="header" class="row"></div>}.must_have_tag('div#header') }
      # ===
      assert_returns_error(%Q{Expected "<div id=\\"header\\" class=\\"row\\"></div>" to NOT have tag ["div#header"], but such a tag was found}) do
        %Q{<div id="header" class="row"></div>}.wont_have_tag('div#header')
      end
      
      assert_no_error { %Q{<div id="header" class="row"></div>}.must_have_tag('div[id=header]') }
      # ===
      assert_returns_error(%Q{Expected "<div id=\\"header\\" class=\\"row\\"></div>" to NOT have tag ["div[id=header]"], but such a tag was found}) do
        %Q{<div id="header" class="row"></div>}.wont_have_tag('div[id=header]')
      end
      
      assert_no_error { %Q{<div id="header" class="row"></div>}.must_have_tag('div.row') }
      # ===
      assert_returns_error(%Q{Expected "<div id=\\"header\\" class=\\"row\\"></div>" to NOT have tag ["div.row"], but such a tag was found}) do
        %Q{<div id="header" class="row"></div>}.wont_have_tag('div.row')
      end
      
      assert_no_error { %Q{<div id="header" class="row"></div>}.must_have_tag('div[class=row]') }
      # ===
      assert_returns_error('Expected "<div id=\\"header\\" class=\\"row\\"></div>" to NOT have tag ["div[class=row]"], but such a tag was found') do
        %Q{<div id="header" class="row"></div>}.wont_have_tag('div[class=row]')
      end
      
      assert_no_error { %Q{<div id="header" class="row"></div>}.must_have_tag('div#header.row') }
      # ===
      assert_returns_error('Expected "<div id=\\"header\\" class=\\"row\\"></div>" to NOT have tag ["div#header.row"], but such a tag was found') do
        %Q{<div id="header" class="row"></div>}.wont_have_tag('div#header.row')
      end
      
      assert_no_error { %Q{<div id="header" class="row"></div>}.must_have_tag('div[id=header][class=row]') }
      # ===
      assert_returns_error('Expected "<div id=\\"header\\" class=\\"row\\"></div>" to NOT have tag ["div[id=header][class=row]"], but such a tag was found') do
        %Q{<div id="header" class="row"></div>}.wont_have_tag('div[id=header][class=row]')
      end
      
      assert_no_error { %Q{<div id="header" class="row columns"></div>}.must_have_tag('div[class=\'row columns\']') }
      # ===
      assert_returns_error('Expected "<div id=\\"header\\" class=\\"row columns\\"></div>" to NOT have tag ["div[class=\'row columns\']"], but such a tag was found') do
        %Q{<div id="header" class="row columns"></div>}.wont_have_tag('div[class=\'row columns\']')
      end
      
    end
    
    it 'should handle an basic <div...> tag with id and class attributes with an incorrectly expected attribute' do
      assert_returns_error(%Q{Expected "<div id=\\"header\\" class=\\"row\\"></div>" to have tag ["div#headers"], but no such tag was found}) do 
        %Q{<div id="header" class="row"></div>}.must_have_tag('div#headers')
      end
      # ===
      assert_no_error { %Q{<div id="header" class="row"></div>}.wont_have_tag('div#headers') }
      
      # ----
      
      assert_returns_error(%Q{Expected "<div id=\\"header\\" class=\\"row\\"></div>" to have tag ["div#header.rows"], but no such tag was found}) do 
        %Q{<div id="header" class="row"></div>}.must_have_tag('div#header.rows')
      end
      # ===
      assert_no_error { %Q{<div id="header" class="row"></div>}.wont_have_tag('div#header.rows') }
    end
    
    it 'should handle a basic <label...> tag with for attribute and nil contents' do
      assert_no_error { %Q{<label for="name">Name:</label>\n}.must_have_tag('label[for=name]', nil) }
      # ===
      assert_returns_error(/to NOT have tag \["label\[for=name\]"\], but such a tag was found/) do 
        %Q{<label for="name">Name:</label>}.wont_have_tag('label[for=name]', nil) 
      end
    end
    
    it 'should handle a basic <label...> tag with for attribute and empty contents' do
      assert_no_error { %Q{<label for="name"></label>}.must_have_tag('label[for=name]', '') }
      
      assert_returns_error('Expected "<label for=\\"name\\">contents</label>" to have tag ["label[for=name]"] with contents [""], but the tag content is [contents]') do
        %Q{<label for="name">contents</label>}.must_have_tag('label[for=name]', '')
      end
      # ===
      assert_returns_error(/to NOT have tag \["label\[for=name\]"\], but such a tag was found/) do 
        %Q{<label for="name"></label>\n}.wont_have_tag('label[for=name]', '') 
      end
      assert_no_error { %Q{<label for="name">contents</label>\n}.wont_have_tag('label[for=name]', '') }
    end
    
    it 'should handle a basic <label...> tag with for attribute and symbol contents' do
      assert_returns_error(/ERROR: contents is neither String nor Regexp, it's \[Symbol\]/) do
        %Q{<label for="name"></label>\n}.must_have_tag('label[for=name]', :symbol)
      end
      # ===
      assert_no_error { %Q{<label for="name"></label>\n}.wont_have_tag('label[for=name]', :symbol) }
    end
    
    it 'should handle a basic <label...> tag with inner_html and empty contents' do
      e = "Expected \"<label for=\\\"name\\\">Username:</label>\" to have tag [\"label[for=name]\"]"
      e << " with contents [\"\"], but the tag content is [Username:]"
      assert_returns_error(e) do
        %Q{<label for="name">Username:</label>}.must_have_tag('label[for=name]', '')
      end
      # ===
      assert_no_error { %Q{<label for="name">Username:</label>}.wont_have_tag('label[for=name]', '') }
    end
    
    it 'should handle a basic <label...> tag with for attribute and contents' do
      assert_no_error { %Q{<label for="name">Name:</label>\n}.must_have_tag('label[for=name]', 'Name:') }
      # ===
      assert_returns_error("Expected \"<label for=\\\"name\\\">Name:</label>\" to NOT have tag [\"label[for=name]\"], but such a tag was found") do
        %Q{<label for="name">Name:</label>}.wont_have_tag('label[for=name]', 'Name:')
      end
      # ---
      
      assert_no_error { %Q{<label for="name">User Name:</label>\n}.must_have_tag('label[for=name]', 'User Name:') }
      # ===
      assert_returns_error('Expected "<label for=\\"name\\">User Name:</label>" to NOT have tag ["label[for=name]"], but such a tag was found') do
        %Q{<label for="name">User Name:</label>}.wont_have_tag('label[for=name]', 'User Name:')
      end
      
    end
    
    it "should handle a basic <label...> tag with for attribute and contents with incorrect expectations" do
      assert_no_error { %Q{<label for="name">Name:</label>\n}.must_have_tag('label[for=name]', 'Name:') }
      # ===
      assert_returns_error('Expected "<label for=\\"name\\">Name:</label>" to NOT have tag ["label[for=name]"], but such a tag was found') do
        %Q{<label for="name">Name:</label>}.wont_have_tag('label[for=name]', 'Name:')
      end
    end
    
    it 'should handle a basic <label...> tag with for attribute and Regexp contents' do
      assert_no_error { %Q{<label for="name">Username:</label>\n}.must_have_tag('label[for=name]', /User/) }
      # ===
      assert_returns_error('Expected "<label for=\\"name\\">Username:</label>" to NOT have tag ["label[for=name]"], but such a tag was found') do
        %Q{<label for="name">Username:</label>}.wont_have_tag('label[for=name]', /User/)
      end
      
      # ----
      
      assert_no_error { %Q{<label for="name">User Name:</label>\n}.must_have_tag('label[for=name]', /user/i) }
      # ===
      assert_returns_error('Expected "<label for=\\"name\\">User Name:</label>" to NOT have tag ["label[for=name]"], but such a tag was found') do
        %Q{<label for="name">User Name:</label>}.wont_have_tag('label[for=name]', /user/i)
      end
    end
    
    it 'should handle a basic <label...> tag with for attribute and Regexp contents' do
      e = "Expected \"<label for=\\\"name\\\">Username:</label>\" to have tag [\"label[for=name]\"]"
      e << " with inner_html [Username:], but did not match Regexp [/Users/]"
      
      assert_returns_error(e) do
        %Q{<label for="name">Username:</label>}.must_have_tag('label[for=name]', /Users/)
      end
      # ===
      assert_no_error { %Q{<label for="name">Username:</label>}.wont_have_tag('label[for=name]', /Users/) }
      
      # ----
      
      assert_returns_error(e.sub('Regexp [/Users/]', 'Regexp [/users/i]')) do
        %Q{<label for="name">Username:</label>}.must_have_tag('label[for=name]', /users/i)
      end
      # ===
      assert_no_error { %Q{<label for="name">Username:</label>}.wont_have_tag('label[for=name]', /users/i) }
      
    end
    
  end
  
end


