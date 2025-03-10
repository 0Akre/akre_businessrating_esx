ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("business_rating:addReview", function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local name = data.anonymous and Config.Locale.anonymous_name or (xPlayer.getName())

    MySQL.Async.execute('INSERT INTO business_ratings (business_name, player_name, rating, review, anonymous) VALUES (?, ?, ?, ?, ?)', {
        data.business,
        data.anonymous and nil or name,
        data.rating,
        data.review,
        data.anonymous
    })
end)

ESX.RegisterServerCallback("business_rating:getReviews", function(source, cb, business)
    MySQL.Async.fetchAll('SELECT * FROM business_ratings WHERE business_name = ?', { business }, function(result)
        cb(result or {})
    end)
end)