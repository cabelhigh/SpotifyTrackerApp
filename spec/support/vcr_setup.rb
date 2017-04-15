VCR.configure do |c|
  c.cassette_library_dir 'spec/vcr' #directory where we will store our cassettes
  c.hook_into :typhoeus #http gem
end
