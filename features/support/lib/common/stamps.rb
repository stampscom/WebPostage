module Stamps

  def service_to_sym(str)
    str.downcase.tr('()', '').tr('/-', '_').strip.tr(' ', '_').to_sym
  end

  def service_to_words(str)
    str.tr('()', '').tr(' /-', ' ')
  end

  def to_sym(str, delim)
    #str.gsub(/[^0-9A-Za-z -]/, '').gsub(/\s+/,'_').gsub(/-+/, '_').downcase.to_sym
    (strip str.gsub(/\W/, delim), delim).downcase.to_sym
  end

  def strip(string, chars)
    chars = Regexp.escape(chars)
    string.gsub(/\A[#{chars}]+|[#{chars}]+\z/, "")
  end

  def browser_helper
    BrowserHelper.instance
  end

  def self.browser
    Stamps::Browser::Browser.instance
  end

  def self.setup *args
    begin
      if args.length == 1
        ENV['BROWSER'] = args[0]
      end
      log "Begin..."

      log "Executed Shell Command:  taskkill /im chrome.exe /f Result=[ #{system "gem list"} ]"

      if Stamps.browser.explorer?
        begin
          log "Executed Shell Command:  taskkill /im iexplore.exe /f [ #{system "taskkill /im iexplore.exe /f"} ]"
        rescue
          #ignore
        end


        browser = Watir::Browser.new :ie
        browser_name = 'Internet Explorer'

      elsif Stamps.browser.chrome?
        begin
          log "Executed Shell Command:  taskkill /im chrome.exe /f Result=[ #{system "taskkill /im chrome.exe /f"} ]"
        rescue
          #ignore
        end

        browser_name = 'Google Chrome'
        chrome_data_dir = "C:\\Users\\#{ENV['USERNAME']}\\AppData\\Local\\Google\\Chrome\\User Data\\Default" #	C:\Users\rcruz\AppData\Local\Google\Chrome\User Data\Default
        chrome_driver_path = "C:\\selenium\\drivers\\chromedriver.exe"

        log_param "chrome_driver:  exist?  #{File.exist? chrome_driver_path}  ##", chrome_driver_path
        log_param "chrome_data_dir:  exist?  #{File.exist? chrome_data_dir}  ##", chrome_data_dir

        begin
          raise log "Chrome Data Directory does not exist on this execution node:  #{chrome_data_dir}"
        end unless File.exist? chrome_data_dir

        prefs = {
            :download => {
                :prompt_for_download => false,
                :default_directory => chrome_data_dir
            }
        }

        profile = Selenium::WebDriver::Chrome::Profile.new
#
        user_data_dir = "user-data-dir=#{chrome_data_dir}"
#--user-data-dir="C:\Users\rcruz\AppData\Local\Temp\scoped_dir19560_20237"
        log "Launching #{browser_name}..."
        Selenium::WebDriver::Chrome.driver_path = chrome_driver_path
        browser = Watir::Browser.new :chrome, :switches => ["--user-data-dir=#{chrome_data_dir}"]
        log "#{browser_name} instantiated."
        #browser = Watir::Browser.new :chrome, :switches => ["--user_data_dir=C:\\Users\\#{ENV['USERNAME']}\\AppData\\Local\\Google\\Chrome\\User Data", "--ignore-certificate-errors", "--disable-popup-blocking", "--disable-translate]"]
        #browser = Watir::Browser.new :chrome, :prefs => prefs
      elsif Stamps.browser.firefox?
        begin
          #log "Executed Shell Command:  taskkill /im firefox.exe /f [ #{system "taskkill /im firefox.exe /f"} ]"
        rescue
          #ignore
        end
        browser = Watir::Browser.new :firefox, :profile => 'selenium'
        browser_name = 'Firefox'
      else
        browser = Watir::Browser.new :ie
        browser_name = 'Internet Explorer'
      end

      log_param 'Browser', browser_name
      #browser.window.move_to 0, 0
      #browser.window.resize_to 1250, 850
      @browser = browser
    rescue Exception => e
      log e
      raise e
    end

  end

  def self.teardown
    @browser.quit unless @browser == nil
    @browser = nil
    log "Done!"
  end

  def test_helper
    TestHelper.instance
  end

  class TestHelper
    include Singleton
    include DataMagic

    def remove_dollar_sign str
      strip str, '$', ''
    end

    def strip str, char_to_remove, substitute_char
      str.gsub(char_to_remove, substitute_char)
    end

    def date_picker_calendar_date day
      now = Date.today
      "#{now.strftime("%B")} #{now.day + day.to_i}"
    end

    def print_date *args
      case args.length
        when 0
          now = Date.today
          log "Today:  #{now}"
          month = (now.month.to_s.length==1)?"0#{now.month}":now.month
          day = (now.day.length==1)?"0#{now.day}":now.day
          "#{month}/#{day}/#{now.year}"
        when 1
          now = Date.today
          log "Today:  #{now}"
          days_to_add = args[0].to_i
          new_date = now + days_to_add
          log "New Date:  #{new_date}"
          month = (new_date.month.to_s.length==1)?"0#{new_date.month}":new_date.month
          day = (new_date.day.to_s.length==1)?"0#{new_date.day}":new_date.day
          now = "#{month}/#{day}/#{new_date.year}"
          now
        else
          raise "Illegal number of arguments for TestHelper.date_from_today"
      end
    end

    def random_name
      "#{random_string} #{random_string}".split.map(&:capitalize).join(' ')
    end

    def random_company_name
      "#{random_string}#{random_string}".split.map(&:capitalize).join(' ')
    end

    def random_alpha_numeric *args
      case args.length
        when 0
          @length = 10
        when 1
          @length = args[0]
        else
          raise "Illegal number of arguments for random_alpha_numeric"

      end
      rstr = rand(36 ** @length - 1).to_s(36).rjust(@length, "0")
    end

    def random_string *args
      case args.length
        when 0
          (0...rand(2..9)).map { (65 + rand(26)).chr }.join
        when 2
          (0...rand(args{0}.to_i..args{1}.to_i)).map { (65 + rand(26)).chr }.join
        else

      end
    end

    def random_phone
      "(#{Random.rand(100..999)}) #{Random.rand(100..999)}-#{Random.rand(1000..9999)}"
    end

    def random_email
      "#{random_string}@#{random_string}.com".downcase
    end

    def random_ship_to
      shipping = select_random_zone_random_address
      shipping["name"] = test_helper.random_name
      shipping["company"] = test_helper.random_company_name
      shipping["phone"] = test_helper.random_phone
      shipping["email"] = test_helper.random_email
      shipping
    end

    def random_suite
      "Suite #{Random.rand(1..999)}"
    end

    def random_ship_from
      us_states = data_for(:us_states, {}) if us_states.nil?
      shipping = select_random_zone_random_address
      shipping["ship_from_zip"] = shipping["zip"]
      shipping["name"] = random_name
      shipping["company"] = random_company_name
      shipping["phone"] = random_phone
      shipping["email"] = random_email
      shipping["state_abbrev"] = shipping["state"]
      shipping["state"] = us_states[shipping["state_abbrev"]]
      shipping["street_address2"] = random_suite
      shipping
    end

    def select_random_zone_random_address
      shipping_addresses_zones = data_for(:shipping_addresses, {})
      zones = shipping_addresses_zones.values
      #pick a random zone
      zone_addresses = zones[rand(zones.size)]
      zone_addresses_values = zone_addresses.values
      #pick a random address from the zone selected above.
      zone_addresses_values[rand(zone_addresses_values.size)]
    end
  end

end