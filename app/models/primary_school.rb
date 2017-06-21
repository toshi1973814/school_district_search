class PrimarySchool < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  # index_name Rails.application.class.parent_name.underscore
  index_name "primary_schools"
  document_type "FeatureCollection"

  def self.search(args={})
    __elasticsearch__.search(
      {
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

end
