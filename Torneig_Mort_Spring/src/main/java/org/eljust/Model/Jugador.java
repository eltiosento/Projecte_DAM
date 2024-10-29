package org.eljust.Model;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@Entity
@Table(name = "Jugador")
@NoArgsConstructor
public class Jugador {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id_jugador")
	private Long idJugador;

	@Column(name = "nom", nullable = false)
	private String nom;
	
	@Column(name = "edat", columnDefinition = "int default 9")
	private int edat;

	@Column(name = "sancionat", columnDefinition = "boolean default false")
	private boolean sancionat;
	
	
	@ManyToMany(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinTable(name = "JugadorEquip", joinColumns = {
			@JoinColumn(name = "id_jugador", foreignKey = @ForeignKey(name = "FK_Jugador_JugadorEquip")) }, inverseJoinColumns = {
					@JoinColumn(name = "id_equip", foreignKey = @ForeignKey(name = "FK_Equip_JugadorEquip")) })
	@ToString.Exclude
	private List<Equip> elsEquips = new ArrayList<>();

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Jugador other = (Jugador) obj;
		if (idJugador == null) {
			if (other.idJugador != null)
				return false;
		} else if (!idJugador.equals(other.idJugador))
			return false;
		return true;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((idJugador == null) ? 0 : idJugador.hashCode());
		return result;
	}
}
