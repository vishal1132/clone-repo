#!/usr/bin/ruby -w
require 'optparse'
require 'net/http'
require 'uri'
require 'json'

options = {}
OptionParser.new do |opts|
    opts.banner = "Usage: main.rb [options]"
    opts.on("-o", "--org <org>", "Github Organization") do |o|
        options[:org] = o
    end
    opts.on("-t", "--token <token>", "Github Personal Access Token") do |t|
        options[:token] = t
    end
    opts.on("-n","--num <num-repos>", "Number of repos in your GH org.") do |n|
        options[:num] = n
    end
    opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
    end
    end.parse!

if options[:org].nil? || options[:token].nil?
    puts "specifiying organization and token is mandatory"
    exit
end

org,token,num,$i=options[:org],options[:token],100,1
if options[:num]
    num=options[:num]
end
num=num.to_i
numPages=num%100==0?num/100:(num/100+1)

while $i <= numPages  do
    apiurl="https://api.github.com/orgs/#{org}/repos?per_page=100&page=#{$i}"
    uri = URI.parse(apiurl)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl=true
    http = http.start
    request = Net::HTTP::Get.new(URI.encode(apiurl))
    request.basic_auth("#{token}", "x-oauth-basic")
    response = http.request(request)
    res=JSON.parse(response.body)
    res.each do |repo|
        puts "Cloning "<<repo["name"]<< " ssh url for the same is- "<< repo["ssh_url"]
        cloneCommand="git clone #{repo["ssh_url"]}"
        system(cloneCommand)
    end
    
    $i +=1
end