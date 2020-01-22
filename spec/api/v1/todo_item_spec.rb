# frozen_string_literal: true

require 'rails_helper'

describe "Todo Items Management", type: :request do
  describe 'GET api/v1/todo_items' do

    context 'Get all todo items' do
      before do
        2.times { create(:todo_item, :pending) }
        get '/api/v1/todo_items.json'
      end

      it 'returns all todo items' do
        expect(response).to have_http_status 200
        expect(parse_json.count).to eq(2)
      end
    end

    context 'Pagination' do
      before do
        3.times { create(:todo_item, :pending) }
        get '/api/v1/todo_items.json?page=1', limit: 2
      end

      it 'returns todo items depending on `per page` settings' do
        expect(response).to have_http_status 200
        expect(parse_json.count).to eq(2)
      end
    end
  end

  describe 'POST api/v1/todo_items' do
    context 'Creates new todo with complete data' do
      let(:todo_params) { {"todo_item": {"title": "Buy shirt"}} }

      before do
        post '/api/v1/todo_items.json', todo_params
      end
      it 'creates new todo item successfully' do
        expect(response).to have_http_status 201
        expect(parse_json["title"]).to eq "Buy shirt"
      end
    end

    context 'Do not create new todo if having incomplete data' do
      let(:todo_params) { {"todo_item": {"title": ""}} }

      before do
        post '/api/v1/todo_items.json', todo_params
      end
      it 'throws error with missing data' do
        expect(response).to have_http_status 422
        expect(parse_json["errors"]["title"]).to eq ["can't be blank"]
      end
    end

    context 'Do not create todo if already exists' do
      let(:todo)        { create(:todo_item, title: "Buy shirt") }
      let(:todo_params) { {"todo_item": {"title": todo.title}} }

      before do
        post "/api/v1/todo_items.json", todo_params
      end
      it 'throws error with already taken' do
        expect(response).to have_http_status 422
        expect(parse_json["errors"]["title"]).to eq ["is already taken"]
      end
    end
  end

  describe 'PATCH api/v1/todo_items/:id' do
    context 'updates todo with complete data' do
      let(:todo)        { create(:todo_item, title: "Buy shirt") }
      let(:todo_params) { {"todo_item": {"title": "Buy jeans"}} }

      before do
        patch "/api/v1/todo_items/#{todo.id}.json", todo_params
      end
      it 'has updated the todo successfully' do
        expect(response).to have_http_status 200
        expect(parse_json["title"]).to eq "Buy jeans"
      end
    end

    context 'Do not update the todo if having incomplete data' do
      let(:todo)        { create(:todo_item, title: "Buy shirt") }
      let(:todo_params) { {"todo_item": {"title": ""}} }

      before do
        patch "/api/v1/todo_items/#{todo.id}.json", todo_params
      end
      it 'throws error with missing data' do
        expect(response).to have_http_status 422
        expect(parse_json["errors"]["title"]).to eq ["can't be blank"]
      end
    end

    context 'Attach tags to todo item' do
      let(:tag)         { create(:tag) }
      let(:todo)        { create(:todo_item) }
      let(:todo_params) { {"todo_item": {"tag_ids": [tag.id]}} }

      before do
        patch "/api/v1/todo_items/#{todo.id}.json", todo_params
      end
      it 'attach tags successfully' do
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'DELETE api/v1/todo_items/:id' do
    context 'Soft Delete todo item' do
      let(:todo)        { create(:todo_item, title: "Buy Shirt") }

      before do
        delete "/api/v1/todo_items/#{todo.id}.json"
      end
      it 'has deleted the todo temporarily' do
        expect(response).to have_http_status 204
      end
    end
  end

  describe 'Restore api/v1/todo_items/:id' do
    context 'Restore Deleted todo item' do
      let(:todo)        { create(:todo_item, :deleted, title: "Buy Shirt") }

      before do
        patch "/api/v1/todo_items/#{todo.id}/restore.json"
      end
      it 'has restored the todo successfully' do
        expect(response).to have_http_status 200
        expect(parse_json["title"]).to eq "Buy Shirt"
      end
    end
  end

  describe 'GET api/v1/tags/:id/todo_items' do
    context "Get tag's todo_items" do
      let(:todo)        { create(:todo_item, :with_tag) }

      before do
        get "/api/v1/tags/#{todo.tags.last.id}/todo_items.json"
      end
      it 'find and returns todos of this tag' do
        expect(response).to have_http_status 200
        expect(parse_json.first["title"]).to eq(todo.title)
      end
    end
  end
end
