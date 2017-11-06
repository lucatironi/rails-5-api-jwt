require 'rails_helper'

RSpec.describe AuthenticationsController, type: :routing do
  it { expect(post: '/authentications').to route_to('authentications#create') }
end
