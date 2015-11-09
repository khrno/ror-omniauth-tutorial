Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 1707955192767009, '76aacf25ca4472e0edd8b67e254aaa53'
  provider :twitter, 'KXt2vqosFVQZdvXievvcXXgO8', 'nRX6rDSoLbHaDiuBRfGI21C1Qqn6loilytbwa66GXekL89HDKI'
end