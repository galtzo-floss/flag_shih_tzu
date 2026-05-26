# frozen_string_literal: true

class Spaceship < ActiveRecord::Base
  self.table_name = "spaceships"
  include FlagShihTzu

  has_flags 1 => :warpdrive,
    2 => :shields,
    3 => :electrolytes
end

class SpaceshipWithoutNamedScopes < ActiveRecord::Base
  self.table_name = "spaceships"
  include FlagShihTzu

  has_flags(
    1 => :warpdrive,
    :named_scopes => false,
  )
end

class SpaceshipWithoutNamedScopesOldStyle < ActiveRecord::Base
  self.table_name = "spaceships"
  include FlagShihTzu

  has_flags(
    {1 => :warpdrive},
    named_scopes: false,
  )
end

class SpaceshipWithCustomFlagsColumn < ActiveRecord::Base
  self.table_name = "spaceships_with_custom_flags_column"
  include FlagShihTzu

  has_flags(
    1 => :warpdrive,
    2 => :hyperspace,
    :column => "bits",
  )
end

class SpaceshipWithColumnNameAsSymbol < ActiveRecord::Base
  self.table_name = "spaceships_with_custom_flags_column"
  include FlagShihTzu

  has_flags(
    1 => :warpdrive,
    2 => :hyperspace,
    :column => :bits,
  )
end

class SpaceshipWith2CustomFlagsColumn < ActiveRecord::Base
  self.table_name = "spaceships_with_2_custom_flags_column"
  include FlagShihTzu

  has_flags(
    {1 => :warpdrive, 2 => :hyperspace},
    column: "bits",
  )
  has_flags(
    {1 => :jeanlucpicard, 2 => :dajanatroj},
    column: "commanders",
  )
end

class SpaceshipWith3CustomFlagsColumn < ActiveRecord::Base
  self.table_name = "spaceships_with_3_custom_flags_column"
  include FlagShihTzu

  has_flags(
    {
      1 => :warpdrive,
      2 => :hyperspace,
    },
    column: "engines",
  )
  has_flags(
    {
      1 => :photon,
      2 => :laser,
      3 => :ion_cannon,
      4 => :particle_beam,
    },
    column: "weapons",
  )
  has_flags(
    {
      1 => :power,
      2 => :anti_ax_routine,
    },
    column: "hal3000",
  )
end

class SpaceshipWithInListQueryMode < ActiveRecord::Base
  self.table_name = "spaceships"
  include FlagShihTzu

  has_flags(1 => :warpdrive, 2 => :shields, :flag_query_mode => :in_list)
end

class SpaceshipWithBitOperatorQueryMode < ActiveRecord::Base
  self.table_name = "spaceships"
  include FlagShihTzu

  has_flags(1 => :warpdrive, 2 => :shields, :flag_query_mode => :bit_operator)
end

class SpaceshipWithBangMethods < ActiveRecord::Base
  self.table_name = "spaceships"
  include FlagShihTzu

  has_flags(1 => :warpdrive, 2 => :shields, :bang_methods => true)
end

class SpaceshipWithMissingFlags < ActiveRecord::Base
  self.table_name = "spaceships"
  include FlagShihTzu

  has_flags 1 => :warpdrive,
    3 => :electrolytes
end

class SpaceCarrier < Spaceship
end

if ActiveRecord::VERSION::MAJOR >= 3
  class SpaceshipWithSymbolAndStringFlagColumns < ActiveRecord::Base
    self.table_name = "spaceships_with_symbol_and_string_flag_columns"
    include FlagShihTzu

    has_flags(
      {
        1 => :warpdrive,
        2 => :hyperspace,
      },
      column: :peace,
      check_for_column: true,
    )
    has_flags(
      {
        1 => :photon,
        2 => :laser,
        3 => :ion_cannon,
        4 => :particle_beam,
      },
      column: :love,
      check_for_column: true,
    )
    has_flags(
      {
        1 => :power,
        2 => :anti_ax_routine,
      },
      column: "happiness",
      check_for_column: true,
    )
    validates_presence_of_flags :peace, :love
  end

  class SpaceshipWithValidationsAndCustomFlagsColumn < ActiveRecord::Base
    self.table_name = "spaceships_with_custom_flags_column"
    include FlagShihTzu

    has_flags(1 => :warpdrive, 2 => :hyperspace, :column => "bits")
    validates_presence_of_flags :bits
  end

  class SpaceshipWithValidationsAnd3CustomFlagsColumn < ActiveRecord::Base
    self.table_name = "spaceships_with_3_custom_flags_column"
    include FlagShihTzu

    has_flags(
      {1 => :warpdrive, 2 => :hyperspace},
      column: "engines",
    )
    has_flags(
      {1 => :photon, 2 => :laser, 3 => :ion_cannon, 4 => :particle_beam},
      column: "weapons",
    )
    has_flags(
      {1 => :power, 2 => :anti_ax_routine},
      column: "hal3000",
    )

    validates_presence_of_flags :engines, :weapons
  end

  class SpaceshipWithValidationsOnNonFlagsColumn < ActiveRecord::Base
    self.table_name = "spaceships_with_custom_flags_column"
    include FlagShihTzu

    has_flags(1 => :warpdrive, 2 => :hyperspace, :column => "bits")
    validates_presence_of_flags :id
  end
end

# table planets is missing intentionally to see if
#   flag_shih_tzu handles missing tables gracefully
class Planet < ActiveRecord::Base
end
