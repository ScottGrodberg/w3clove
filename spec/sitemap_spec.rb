# -*- encoding: utf-8 -*-

require_relative 'spec_helper'

describe W3Clove::Sitemap do
  before(:each) do
    @sitemap                              = W3Clove::Sitemap.new('http://ryanair.com/sitemap.xml')
    @sitemap_html                         = W3Clove::Sitemap.new('http://guides.rubyonrails.org')
    @sitemap_no_links                     = W3Clove::Sitemap.new('http://zigotica.com')
    @sitemap_with_trailing_slash          = W3Clove::Sitemap.new('http://eparreno.com')
    @sitemap_with_protocol_relative       = W3Clove::Sitemap.new('http://protocol-relative.com')
    @sitemap_with_protocol_relative_https = W3Clove::Sitemap.new('https://protocol-relative.com')

    MarkupValidator.any_instance.stubs(:validate_uri).returns(stubbed_validator_results)
  end

  it "should have an URL" do
    @sitemap.url.should == 'http://ryanair.com/sitemap.xml'
  end

  describe "scraping pages" do
    it "should get its pages from a xml sitemap" do
      @sitemap.pages.length.should == 3
      @sitemap.pages[0].url.should == 'http://www.ryanair.com/es/'
      @sitemap.pages[1].url.should == 'http://www.ryanair.com/es/careers/job'
      @sitemap.pages[2].url.should == 'http://www.ryanair.com/es/about'
    end

    it "should get pages from the sample guides.rubyonrails.org site" do
      @sitemap_html.pages.length.should == 33
      @sitemap_html.pages.map {|p| p.url}
        .should == ["http://guides.rubyonrails.org/index.html",
                    "http://guides.rubyonrails.org/",
                    "http://guides.rubyonrails.org/getting_started.html",
                    "http://guides.rubyonrails.org/migrations.html",
                    "http://guides.rubyonrails.org/active_record_validations_callbacks.html",
                    "http://guides.rubyonrails.org/association_basics.html",
                    "http://guides.rubyonrails.org/active_record_querying.html",
                    "http://guides.rubyonrails.org/layouts_and_rendering.html",
                    "http://guides.rubyonrails.org/form_helpers.html",
                    "http://guides.rubyonrails.org/action_controller_overview.html",
                    "http://guides.rubyonrails.org/routing.html",
                    "http://guides.rubyonrails.org/active_support_core_extensions.html",
                    "http://guides.rubyonrails.org/i18n.html",
                    "http://guides.rubyonrails.org/action_mailer_basics.html",
                    "http://guides.rubyonrails.org/testing.html",
                    "http://guides.rubyonrails.org/security.html",
                    "http://guides.rubyonrails.org/debugging_rails_applications.html",
                    "http://guides.rubyonrails.org/performance_testing.html",
                    "http://guides.rubyonrails.org/configuring.html",
                    "http://guides.rubyonrails.org/command_line.html",
                    "http://guides.rubyonrails.org/caching_with_rails.html",
                    "http://guides.rubyonrails.org/plugins.html",
                    "http://guides.rubyonrails.org/rails_on_rack.html",
                    "http://guides.rubyonrails.org/generators.html",
                    "http://guides.rubyonrails.org/contributing_to_ruby_on_rails.html",
                    "http://guides.rubyonrails.org/api_documentation_guidelines.html",
                    "http://guides.rubyonrails.org/ruby_on_rails_guides_guidelines.html",
                    "http://guides.rubyonrails.org/3_0_release_notes.html",
                    "http://guides.rubyonrails.org/2_3_release_notes.html",
                    "http://guides.rubyonrails.org/2_2_release_notes.html",
                    "http://guides.rubyonrails.org/contribute.html",
                    "http://guides.rubyonrails.org/credits.html",
                    "http://guides.rubyonrails.org/v2.3.8/"]
    end

    it "should include sitemap url at least, even if no links were found" do
      @sitemap_no_links.pages.length.should == 1
      @sitemap_no_links.pages[0].url.should == 'http://zigotica.com'
    end

    it "should not repeat URLs with and without trailing slash" do
      urls = @sitemap_with_trailing_slash.pages.collect(&:url)
      urls.should      include 'http://eparreno.com/'
      urls.should_not  include 'http://eparreno.com'
    end

    context "protocol-relative links" do
      it "should include only internal links" do
        @sitemap_with_protocol_relative.pages.size.should == 3
        @sitemap_with_protocol_relative.pages.map {|p| p.url}.sort.should == ['http://protocol-relative.com/',
                                                                              'http://protocol-relative.com/contact',
                                                                              'http://protocol-relative.com/faqs']
      end

      it "should include protocol-relative link to same domain" do
        @sitemap_with_protocol_relative.pages.map {|p| p.url}.should include 'http://protocol-relative.com/contact'
      end

      it "should have the same protocol than the root url" do
        @sitemap_with_protocol_relative_https.pages.map {|p| p.url}.should include 'https://protocol-relative.com/contact'
      end

      it "should not include protocol-relative link to another domain" do
        @sitemap_with_protocol_relative.pages.map {|p| p.url}.should_not include 'http://yahoo.com'
      end
    end
  end

  describe "validations" do
    it "should know the errors of all of its pages as a whole" do
      @sitemap.errors.length.should == 9
      @sitemap.errors.each do |e|
        e.should be_an_instance_of W3Clove::Message
        e.type.should == :error
      end
    end

    it "should know the warnings of all of its pages as a whole" do
      @sitemap.warnings.length.should == 9
      @sitemap.warnings.each do |w|
        w.should be_an_instance_of W3Clove::Message
        w.type.should == :warning
      end
    end
  end
end