class Document
  include Mongoid::Document
  include Mongoid::Timestamps

  ACCESS_RIGHTS = [:public, :pii_restricted]
  TYPE_KINDS 		= [:collection, 
											:dataset,
											:event,
											:image,
											:interactive_resource,
											:service,
											:software,
											:sound,
											:text
										]

  # Enable polymorphic associations
  embedded_in :documentable, polymorphic: true

  # Dublin Core metadata elements
  field :title, type: String, default: "untitled"

  # Entity responsible for making the resource - person, organization or service
  # This will typically reference the site owner or system service 
  embeds_one	:creator,
  						class_name: 'Parties::Party'

  # Controlled vocabulary w/classification codes. Mapped to ConsumerRole::VLP_DOCUMENT_KINDS
  field :subject, type: String

  # May include but is not limited to: an abstract, a table of contents, a graphical representation, 
  # or a free-text account of the resource
  field :description, type: String

  # Entity responsible for making the resource available - person, organization or service
  embeds_one	:publisher,
  						class_name: 'Parties::Party'

  # Entity responsible for making contributions to the resource - person, organization or service
  # This will typically reference the site owner or system service 
  embeds_many	:contributors,
  						class_name: 'Parties::Party'

  # A point or period of time associated with an event in the lifecycle of the resource.
  embeds_one	:timespan,
  						class_name: 'Timespans::Timespan'

  # Conforms to DCMI Type Vocabulary - http://dublincore.org/documents/2000/07/11/dcmi-type-vocabulary/
  field :type, type: Symbol, default: :text

  # Conforms to IANA mime types - http://www.iana.org/assignments/media-types/media-types.xhtml
  # Common exammples
  # 	PDF => application/pdf
  # 	csv => text/csv
  #   markdown => text/markdown
  # 	xml => 	text/xml
  field :format, type: String, default: "application/pdf"

  # An unambiguous reference to the resource - Conforms to URI
  field :identifier, type: String

  # A related resource from which the described resource is derived
  field :source, type: String, default: "enroll_system"

  # Conforms to ISO 639
  field :language, type: String, default: "en"

  # A related resource - a string conforming to a formal identification system
  field :relation, type: String

  # Spatial (e.g. "District of Columbia") or temporal (e.g. "Open Enrollment 2016") topic of the resource
  field :coverage, type: String

  # Conforms to ACCESS_RIGHTS above
  field :rights, type: String

  field :tags, type: Array, default: []

  field :size, type: String

  validates_presence_of :title, :creator, :publisher, :type, :format, :source, :language

  validates :rights,
    allow_blank: true,
    inclusion: { in: ACCESS_RIGHTS, message: "%{value} is not a valid access right" }

  validates :type,
    allow_blank: true,
    inclusion: { in: TYPE_KINDS, message: "%{value} is not a valid type" }

end
