require 'aws-sdk'

class AwsWrapper
  def initialize(creds)
    @credentials = creds
  end
  def do_s3_test
    resp = client.list_buckets
    puts resp.buckets.map(&:name)
  end

  def sns_send_mesg(arn, mesg)
    resp = client.publish message: mesg,
                          target_arn: arn# 'arn:aws:sns:us-west-2:696247329560:endpoint/APNS/PlaydateNinjaTestFairyDistribution/8ec36409-de2e-36c8-9b6a-ee6061b74509'

    puts "Response mesg ID is #{resp.message_id}"
  end

  def sns_make_endpoint(token)
    staging_platformapp = 'arn:aws:sns:us-west-2:696247329560:app/APNS/PlaydateNinjaTestFairyDistribution'
    client.create_platform_endpoint({
                                      platform_application_arn: staging_platformapp,
                                      token: token,
                                      custom_user_data: "Megan's iphone: scripted"
                                    })
  end

  private
  def client
    @client ||= Aws::SNS::Client.new(credentials: @credentials)
  end
end

ENV['AWS_REGION'] = 'us-west-2'
credentials = Aws::SharedCredentials.new(profile_name: (ARGV[0] || 'default'))

d_token = '596940858ac1dc20a31c9dcdd2d6629b7fec506e767ae27d7f9ea922020a9fdc'
AwsWrapper.new(credentials).sns_make_endpoint(d_token)
