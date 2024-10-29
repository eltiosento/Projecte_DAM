package org.eljust.Model;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "Temporada")
public class Temporada {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id_temporada")
	private Long idTemporada;

	@Column(name = "nom", nullable = false, unique = true)
	private String nom;

	@OneToMany(mappedBy = "laTemporada", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
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
		Temporada other = (Temporada) obj;
		if (idTemporada == null) {
			if (other.idTemporada != null)
				return false;
		} else if (!idTemporada.equals(other.idTemporada))
			return false;
		return true;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((idTemporada == null) ? 0 : idTemporada.hashCode());
		return result;
	}

}
