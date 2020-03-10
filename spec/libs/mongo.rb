require "mongo"

# host: ds035664.mlab.com
# port: 35664
# Database: spotdb
# user: qaninja
# Password: qaninja123

# Mongo::Logger.logger.level = Logger::INFO # Coloca os logs como informativos
Mongo::Logger.logger = Logger.new("./logs/mongo.log") # Cria um log de informações na pasta informada

class MongoDb
  def remove_company(company, user_id)
    query = { company: company, user: user_id.to_mongo_id }
    spots.delete_many(query)
  end

  # salva uma lista de spots
  def save_spots(spot_list)
    spots.delete_many({ user: spot_list.first[:user] })
    spots.insert_many(spot_list)
  end

  # salva um único spot
  def save_spot(spot)
    spots.delete_many({ user: spot[:user] })
    result = spots.insert_one(spot)
    return result.inserted_id
  end

  def mongo_id
    return BSON::ObjectId.new
  end

  private

  # retorna a colletion
  def spots
    return client[:spots]
  end

  # retorna a collection
  def users
    return client[:user]
  end

  def client
    return Mongo::Client.new(CONFIG["mongo_url"])
  end
end
