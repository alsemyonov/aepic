xml.application(
  xsi: 'http://www.w3.org/2001/XMLSchema-instance',
  'xsi:schemaLocation' => 'http://wadl.dev.java.net/2009/02 wadl.xsd',
  xsd: 'http://www.w3.org/2001/XMLSchema',
  xmlns: 'http://wadl.dev.java.net/2009/02') do

  schema = Aepic::Schema.default
  schema.controllers.each do |controller|
    xml.resources base: root_url do
      xml.resource path: "#{controller.controller_name}", id: controller.controller_name do
        controller.action_methods.each do |action|
          xml.method name: schema.method_for(action) do

          end
        end
      end
    end
  end
end
