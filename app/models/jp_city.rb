class JpCity < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  # index_name Rails.application.class.parent_name.underscore
  index_name "jp_city"
  document_type "FeatureCollection"

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :title, analyzer: 'english'
      indexes :body, analyzer: 'english'
    end
  end

  def self.search(args={})
    __elasticsearch__.search(
      {
        _source: {
          exclude: [ "geometry" ]
        },
        query: {
          geo_shape: {
            geometry: {
              relation: "intersects",
              shape: {
                type: "Point",
                coordinates: [args[:lng],args[:lat]],
              }
            }
          }
        }
      }
    )
  end

  def as_indexed_json(options = nil)
    self.as_json( only: [ :title, :body ] )
  end

end
