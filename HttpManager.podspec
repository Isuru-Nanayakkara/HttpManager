Pod::Spec.new do |spec|
  spec.name = 'HttpManager'
  spec.version = '0.1.0'
  spec.summary = 'A small library to handle HTTP requests.'
  spec.homepage = 'https://github.com/Isuru-Nanayakkara/HttpManager'
  spec.license = 'MIT'
  spec.author = { 'Isuru Nanayakkara' => 'isuru.nan@gmail.com' }
  spec.source = { :git => 'https://github.com/Isuru-Nanayakkara/HttpManager.git', :tag => "#{spec.version}" }
  spec.source_files = 'HttpManager/HttpManager/HttpManager.swift'
  spec.requires_arc = true
end
