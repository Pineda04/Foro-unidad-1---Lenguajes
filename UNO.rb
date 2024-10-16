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

# Clase para representar el mazo de cartas
class Mazo
  attr_reader :cartas

  def initialize
    @cartas = []
    crear_cartas
    barajar
  end

  def crear_cartas
    colores = ["Rojo", "Verde", "Azul", "Amarillo"]
    valores = (0..9).to_a

    colores.each do |color|
      valores.each do |valor|
        @cartas << Carta.new(color, valor)
        @cartas << Carta.new(color, valor) unless valor == 0
      end
      # Crear cartas especiales
      @cartas << CartaReversa.new(color)
      @cartas << CartaSaltar.new(color)
      @cartas << CartaMasDos.new(color)
    end
  end

  def barajar
    @cartas.shuffle!
  end

  def sacar_carta
    @cartas.pop
 end
end

# Clase para el jugador
class Jugador
  attr_reader :nombre, :mano

  def initialize(nombre)
    @nombre = nombre
    @mano = []
  end

  def tomar_carta(carta)
    @mano << carta
  end

  def jugar_carta(indice, juego)
    carta = @mano.delete_at(indice)
    puts "#{@nombre} juega #{carta.mostrar}"
    carta.ejecutar_efecto(juego)
    carta
  end

  def mostrar_mano
    @mano.map.with_index { |carta, i| "#{i}: #{carta.mostrar}" }.join("\n")
  end

  def tiene_carta_jugable?(carta_superior)
    @mano.any? { |carta| carta.se_puede_jugar?(carta_superior) }
  end
end

# Clase para representar el juego Uno
class JuegoUno
  attr_reader :mazo

  def initialize(jugadores)
    @mazo = Mazo.new
    @jugadores = jugadores.map { |nombre| Jugador.new(nombre) }
    @turno_actual = 0
    @direccion = 1 # 1 para avanzar, -1 para reversa
    @carta_superior = @mazo.sacar_carta
    repartir_cartas
  end

  def repartir_cartas
    7.times do
      @jugadores.each do |jugador|
        jugador.tomar_carta(@mazo.sacar_carta)
      end
    end
  end

  def iniciar
    loop do
      jugador_actual = @jugadores[@turno_actual]
      puts "\nCarta en la pila: #{@carta_superior.mostrar}"
      puts "\nTurno de: #{jugador_actual.nombre}"
      puts "Tus cartas:\n#{jugador_actual.mostrar_mano}"

      if jugador_actual.tiene_carta_jugable?(@carta_superior)
        puts "Selecciona una carta para jugar (0 a #{jugador_actual.mano.size - 1}):"
        indice = gets.chomp.to_i
        while indice < 0 || indice >= jugador_actual.mano.size || !jugador_actual.mano[indice].se_puede_jugar?(@carta_superior)
          puts "Carta inválida, elige otra:"
          indice = gets.chomp.to_i
        end
        @carta_superior = jugador_actual.jugar_carta(indice, self)
      else
        puts "#{jugador_actual.nombre} no tiene cartas jugables, toma una carta del mazo."
        jugador_actual.tomar_carta(@mazo.sacar_carta)
      end

      if jugador_actual.mano.empty?
        puts "#{jugador_actual.nombre} ha ganado el juego. ¡Felicidades!"
        break
      end

      siguiente_turno
    end
  end

  def cambiar_direccion
    @direccion *= -1
  end

  def saltar_turno
    siguiente_turno
  end

  def siguiente_turno
    @turno_actual = (@turno_actual + @direccion) % @jugadores.length
  end

  def siguiente_jugador
    @jugadores[(@turno_actual + @direccion) % @jugadores.length]
  end
end