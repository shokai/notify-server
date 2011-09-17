class IM
  include Mongoid::Document
  field :message, :type => String
  field :from, :type => String
  field :time, :type => Integer
  def to_hash
    {
      :message => message,
      :from => from,
      :time => time
    }
  end
end
