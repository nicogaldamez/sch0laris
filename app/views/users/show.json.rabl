object @user

if !@user.errors.blank?
  node :errors do |o|
    o.errors
  end
else
  attributes :id, :name
end
