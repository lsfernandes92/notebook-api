require 'rails_helper'

describe "Contacts", type: :request do

  context 'when request with no valid headers' do
    it 'returns status code 406 if no accept sent' do
      get v1_contacts_path

      expect(response.status).to eq 406
    end

    it 'returns status code 415 if no content type sent' do
      get v1_contacts_path, headers: { 'ACCEPT' => 'application/vnd.api+json' }

      expect(response.status).to eq 415
    end
  end

  context 'when resquest with valid headers' do
    let(:headers) { {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT_TYPE' => 'application/vnd.api+json'
    } }

    let(:response_body) { JSON.parse(response.body) }
    let(:contact_first) { Contact.first }
    let(:contact_first_response) { {
      "type" => "contacts",
      "attributes" => {
          "name" => contact_first.name,
          "email" => contact_first.email,
          "birthdate" => contact_first.birthdate.to_time.iso8601
      }
    } }

    describe 'GET v1/contacts' do
      let(:expected_pagination_keys) do        expect(response_body['data']['type']).to eq "contacts"

         ["self", "first", "prev", "next", "last"]
      end

      it 'returns contacts' do
        get v1_contacts_path, headers: headers

        expect(response.status).to eq 200
        expect(response_body['data'].count).to eq 5
        expect(response_body['links'].keys).to eq expected_pagination_keys
      end
    end

    describe 'GET v1/contacts/1' do
      it 'returns only first contact' do
        get '/v1/contacts/1', headers: headers

        expect(response_body['data']['id']).to eq "#{contact_first.id}"
        expect(response_body['data']).to include(contact_first_response)
      end
    end
  end
end
