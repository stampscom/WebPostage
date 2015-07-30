module Batch

  module SingleOrderCommon
    def browser_helper
      BrowserHelper.instance
    end

    def order_status_label
      label = @browser.label :css => "div[id^=orderDetailsPanel]>div[id^=singleOrderDetailsForm]>div>div[id^=container]>div>div>div>div>label"
      present = label.present?
      text = label.text
      label
    end

    def order_status
      browser_helper.text order_status_label, 'order_status'
    end

    def single_order_form_present?
      browser_helper.present? order_status_label
    end

    def ship_to_dropdown
      #@browser.span :css => 'div[id=shiptoview-addressCollapsed-targetEl]>a>span>span>span:nth-child(2)'
      @browser.link :css => 'div[id=shiptoview-addressCollapsed-targetEl]>a'
    end

    def less_dropdown
      @browser.span :text => 'Less'
    end

    def expand_ship_to
      10.times {
        break if browser_helper.present?  address_textbox
        browser_helper.click ship_to_dropdown, "ship_to_address_field" if browser_helper.present?  ship_to_dropdown
      }
    end

    def less
      browser_helper.click less_dropdown, "Less" if browser_helper.present?  less_dropdown
    end

    def item_label
      @browser.label :text => 'Item:'
    end

    def click_item_label
      3.times {
        begin
          item_label.click
        rescue
          #ignore
        end
      }
    end

    def address_textbox
      @browser.textarea :name => 'FreeFormAddress'
    end

    def validate_address_link
      @browser.span :text => 'Validate Address'
    end
  end

end