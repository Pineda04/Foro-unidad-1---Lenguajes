# Esta clase va a ser la base de las demas
class Carta
  attr_reader :color, :valor

  def initialize(color, valor)
    @color = color
    @valor = valor
  end

  def mostrar
    "#{@color} #{@valor}"
  end

  # Ver si se puede usar la carta o no
  def se_puede_jugar?(otra_carta)
    @color == otra_carta.color || @valor == otra_carta.valor
  end

  # Este metodo va a ejecutar el efecto de la carta que por defecto se tomara como normal y no va 
  # a tener ninguno
  def ejecutar_efecto(juego)
    
  end
end

# Aqui ya se crean las demas cartas heredando de la "Carta" de arriba
class CartaReversa < Carta
  def initialize(color)
    super(color, "Reversa")
  end

  def ejecutar_efecto(juego)
    puts "¡Reversa! El orden de juego cambia."
    juego.cambiar_direccion
  end
end

class CartaSaltar < Carta
  def initialize(color)
    super(color, "Saltar")
  end

  def ejecutar_efecto(juego)
    puts "¡Saltar! El siguiente jugador pierde su turno."
    juego.saltar_turno
  end
end

class CartaMasDos < Carta
  def initialize(color)
    super(color, "+2")
  end

  def ejecutar_efecto(juego)
    puts "¡+2! El siguiente jugador toma dos cartas."
    juego.siguiente_jugador.tomar_carta(juego.mazo.sacar_carta) # Aqui parte la logica de como sera parte del gameplay
    juego.siguiente_jugador.tomar_carta(juego.mazo.sacar_carta)
  end
end

# Vos haces la logica del mazo si queres