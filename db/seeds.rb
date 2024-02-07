require 'csv'

csv_file_path = Rails.root.join('storage/transactional-sample.csv')

Rails.logger.info 'Loading DataSample transactions'

CSV.foreach(csv_file_path, headers: true) do |transaction|
  transaction = transaction.to_h.deep_symbolize_keys
  transaction[:chargebacked] = (transaction.delete(:has_cbk) == 'TRUE')
  transaction[:transaction_amount] = BigDecimal(transaction[:transaction_amount])
  transaction[:id] = transaction.delete(:transaction_id).to_i
  %i[merchant_id user_id device_id].each do |field|
    transaction[field] = transaction[field].to_i
  end

  creator = Transactions::Creator.new(transaction_params: transaction)

  creator.run
end
