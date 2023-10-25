class Habitaciones {
	const ocupantes = []
	
	method nivelDeConfortQueAporta(unaPersona) {
		return 10
	}
	
	method puedeEntrarAUnaHabitacion() {
		return ocupantes.size() == 0
	}
	
	method ingresarALaPersona(unaPersona) {
		if(unaPersona.puedeEntrarAUnaHabitacion()) {
			ocupantes.add(unaPersona)
		} else {
			self.error("no puede ingresar a la habitacion")
		}
	}
	
	method cantidadDeOcupantes() {
		return ocupantes.size()
	}
	
	method ocupanteMasViejo() {
		return ocupantes.filter({o => o.edad()})
	}
}

class Dormitorios inherits Habitaciones {
	const personasQueDuermen = []
	
	override method nivelDeConfortQueAporta(unaPersona) {
		if(personasQueDuermen.any({p => p == unaPersona})) {
			return super(unaPersona) + (10 / personasQueDuermen.size())
		} else {
			return super(unaPersona)
		}
	}
	
	override method puedeEntrarAUnaHabitacion() {
		return super() or ocupantes.all({o => self.esPersonaQueDuerme(o)})
	} 
	
	method esPersonaQueDuerme(unaPersona) {
		return personasQueDuermen.contains(unaPersona)
	}
}

class Banios inherits Habitaciones {
	
	override method nivelDeConfortQueAporta(unaPersona) {
		if (unaPersona.edad() <= 4) {
			return super(unaPersona) + 2
		} else {
			return super(unaPersona) + 4
		}
	}
	
	override method puedeEntrarAUnaHabitacion() {
		return super() or ocupantes.any({o => 0.edad() <= 4})
	}
}

class Cocinas inherits Habitaciones {
	const cantidadDeMetrosCuadrados
	var porcentaje = 0.1
	
	override method nivelDeConfortQueAporta(unaPersona) {
		if(unaPersona.tieneHabilidadesDeCocina()) {
			return super(unaPersona) + self.porcentajeQueAporta()
		} else {
			return super(unaPersona)
		}
	}
	
	method porcentajeQueAporta() {
		return cantidadDeMetrosCuadrados * porcentaje
	}
	
	method porcentajeNuevo(unPorcentaje) {
		porcentaje = unPorcentaje
	}
	
	override method puedeEntrarAUnaHabitacion() {
		return super() or ocupantes.any({o => !o.tieneHabilidadesDeCocina()})
	} 
}

class Personas {
	var nivelDeConfort
	const property edad
	var tieneHabilidadesDeCocina
	var habitacionesALasQuePuedeEntrar
	
	method habitacionesALasQuePuedeEntrar() {
		return habitacionesALasQuePuedeEntrar
	}
	
	method nivelDeConfort(unValor) {
		nivelDeConfort = unValor
	}
	
	method tieneHabilidadesDeCocina() {
		return tieneHabilidadesDeCocina
	}
	
	method nivelDeConfortQueAporta(unaHabitacion) {
		nivelDeConfort += unaHabitacion.nivelDeConfortQueAporta(self)
	}
	
	method puedeIngresarALaHabitacion(unaHabitacion) {
		return unaHabitacion.puedeEntrarAUnaHabitacion()
	}
	
	method estaAgusto(unaHabitacion, unaCasa, unaFamilia) {
		return self.puedeIngresarALaHabitacion(unaHabitacion)
	}
}

class Obsesive inherits Personas {
	
	override method estaAgusto(unaHabitacion, unaCasa, unaFamilia) {
		return super(unaHabitacion, unaCasa, unaFamilia) and unaCasa.cantidadDeOcupantes() <= 2
	}
}

class Goloses inherits Personas {
	
	override method estaAgusto(unaHabitacion, unaCasa, unaFamilia) {
		return super(unaHabitacion, unaCasa, unaFamilia) and unaFamilia.hayUnMiembroConHabilidadesDeCocina()
	}
}

class Sencilles inherits Personas {
	
	override method estaAgusto(unaHabitacion, unaCasa, unaFamilia) {
		return super(unaHabitacion, unaCasa, unaFamilia) and unaCasa.cantidadDeHabitaciones() > unaFamilia.cantidadDeMiembros()
	}
}

class Familias {
	const integrantes = []
	const casaEnLaQueViven
	
	method nivelDeConfortPromedio() {
		return integrantes.sum({i => casaEnLaQueViven.confortDeLaCasa(i)}) / self.cantidadDeMiembros()
	}
	
	method cantidadDeMiembros() {
		return integrantes.size()
	}
	
	method estanAgusto(unaHabitacion) {
		return self.nivelDeConfortPromedio() and integrantes.all({i => i.estaAgusto()})
	}
	
	method hayUnMiembroConHabilidadesDeCocina() {
		return integrantes.any({i => i.tieneHabilidadesDeCocina()})
	}
}

class Casas {
	const habitaciones = []
	
	method habitacionesDeLaCasa() {
		return habitaciones.asList()
	}
	
	method habitacionesOcupadas() {
		return habitaciones.filter({h => h.cantidadDeOcupantes() >= 1})
	}
	
	method ocupantesMasViejosDeLaCasa() {
		return habitaciones.filter({h => h.ocupanteMasViejo()})
	}
	
	method confortDeLaCasa(unaPersona) {
		return habitaciones.sum({h => h.nivelDeConfort(unaPersona)})
	}
	
	method cantidadDeOcupantes() {
		return habitaciones.map({h => h.cantidadDeOcupantes()}).asSet()
	}
	
	method cantidadDeHabitaciones() {
		return habitaciones.size()
	}
}

