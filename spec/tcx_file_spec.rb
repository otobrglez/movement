require 'spec_helper'

describe TCXFile do

  subject!{ TCXFile.new("./spec/raw/example.tcx") }

  its(:sport){ should be_kind_of String }
  its(:sport){ should eq "Running"}
  its(:distance){ should be_kind_of Float }
  its(:geo_information){ should be_kind_of Array }
  its(:points){ should be_kind_of Array }
  its(:altitudes){ should be_kind_of Array }

end
