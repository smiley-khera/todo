# frozen_string_literal: true

require 'rails_helper'

describe "Tags Management", type: :request do
  describe 'GET api/v1/tags' do

    context 'Get all tags' do
      before do
        2.times { create(:tag) }
        get '/api/v1/tags.json'
      end

      it 'returns all tags' do
        expect(response).to have_http_status 200
        expect(parse_json.count).to eq(2)
      end
    end

    context 'Pagination' do
      before do
        3.times { create(:tag) }
        get '/api/v1/tags.json?page=1', limit: 2
      end

      it 'returns tags depending on `per page` settings' do
        expect(response).to have_http_status 200
        expect(parse_json.count).to eq(2)
      end
    end
  end

  describe 'POST api/v1/tags' do
    context 'Creates new tag with complete data' do
      let(:tag_params) { {"tag": {"name": "shopping"}} }

      before do
        post '/api/v1/tags.json', tag_params
      end
      it 'creates new tag successfully' do
        expect(response).to have_http_status 201
        expect(parse_json["name"]).to eq "shopping"
      end
    end

    context 'Do not create new tag if having incomplete data' do
      let(:tag_params) { {"tag": {"name": ""}} }

      before do
        post '/api/v1/tags.json', tag_params
      end
      it 'throws error with missing data' do
        expect(response).to have_http_status 422
        expect(parse_json["errors"]["name"]).to eq ["can't be blank"]
      end
    end

    context 'Do not create the tag if already exists' do
      let(:tag)        { create(:tag, name: "shopping") }
      let(:tag_params) { {"tag": {"name": tag.name}} }

      before do
        post "/api/v1/tags.json", tag_params
      end
      it 'throws error with already taken' do
        expect(response).to have_http_status 422
        expect(parse_json["errors"]["name"]).to eq ["is already taken"]
      end
    end
  end

  describe 'PATCH api/v1/tags/:id' do
    context 'updates tag with complete data' do
      let(:tag)        { create(:tag, name: "shopping") }
      let(:tag_params) { {"tag": {"name": "kitchen"}} }

      before do
        patch "/api/v1/tags/#{tag.id}.json", tag_params
      end
      it 'has updated the tag successfully' do
        expect(response).to have_http_status 200
      end
    end

    context 'Do not update the tag if having incomplete data' do
      let(:tag)        { create(:tag, name: "shopping") }
      let(:tag_params) { {"tag": {"name": ""}} }

      before do
        patch "/api/v1/tags/#{tag.id}.json", tag_params
      end
      it 'throws error with missing data' do
        expect(response).to have_http_status 422
        expect(parse_json["errors"]["name"]).to eq ["can't be blank"]
      end
    end
  end

  describe 'DELETE api/v1/tags/:id' do
    context 'Delete the tag' do
      let(:tag)        { create(:tag, name: "shopping") }

      before do
        delete "/api/v1/tags/#{tag.id}.json"
      end
      it 'has deleted the tag successfully' do
        expect(response).to have_http_status 204
      end
    end
  end
end
