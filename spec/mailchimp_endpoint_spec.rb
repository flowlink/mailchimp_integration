require 'spec_helper'

describe MailChimpEndpoint do
  describe 'POST /add_order' do
    let(:payload) do
      {
        request_id: "12e12341523e449c3000001",
        parameters: {
          mailchimp_api_key:"apikey-us8"
        },
        order: Hub::Samples::Order.object["order"].merge(id: "123", email: "bruno@spreecommerce.com")
      }
    end

    it 'sends order to mailchimp' do
      VCR.use_cassette('mailchimp_add_order') do
        post '/add_order', payload.to_json, auth

        expect(last_response.status).to eql 200
        expect(json_response["summary"]).to eq "Order 123 has been sent to MailChimp"
        expect(json_response["request_id"]).to eql "12e12341523e449c3000001"
      end
    end
  end

  describe 'POST /add_to_list' do
    context 'list_id is in root' do
      let(:payload) {
        '{"request_id": "12e12341523e449c3000001",
          "parameters": {
            "mailchimp_api_key":"apikey"
          },
          "list_id":"a5b08674ef",
          "member": {
            "email": "support@spreecommerce.com",
            "first_name": "Spree",
            "last_name": "Commerce"
          }
        }'
      }

      it "should respond to POST add_to_list" do
        VCR.use_cassette('mailchimp_add') do
          post '/add_to_list', payload, auth

          expect(last_response.status).to eql 200
          expect(json_response["request_id"]).to eql "12e12341523e449c3000001"
          expect(json_response["summary"]).to match /Successfully subscribed/
        end
      end
    end

    context 'multiple list_id inside member body' do
      let(:payload) {
        '{"request_id": "12e12341523e449c3000001",
          "parameters": {
            "mailchimp_api_key":"apikey"
          },
          "member": {
            "email": "bruno+mailchampion@spreecommerce.com",
            "first_name": "Bruno",
            "last_name": "Buccolo",
            "list_id":["a5b08674ef","fa2c2d7aed"]
          }
        }'
      }

      it "should respond to POST add_to_list" do
        VCR.use_cassette('mailchimp_multiple_add') do
          post '/add_to_list', payload, auth

          expect(last_response.status).to eql 200
          expect(json_response["request_id"]).to eql "12e12341523e449c3000001"
          expect(json_response["summary"]).to match /Successfully subscribed/
        end
      end
    end
  end
end
