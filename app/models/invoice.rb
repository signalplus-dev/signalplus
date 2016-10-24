class Invoice < ApplicationRecord
	belongs_to :brand
	belongs_to :subscription

end
