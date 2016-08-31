class SMSSender
  def self.send(phone, content)
    return {success: true, code: '1231232132'} if Rails.env.test?

    ChinaSMS.use(:yunxin, 
                 username: ENV['YUNXIN_USER_NAME'], 
                 password: ENV['YUNXIN_PASSWORD'])

    ChinaSMS.to(phone, content)
  end
end
