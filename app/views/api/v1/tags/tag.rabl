attributes :id, :name
node (:url)  {|tag| tag_url(tag, format: :json)}