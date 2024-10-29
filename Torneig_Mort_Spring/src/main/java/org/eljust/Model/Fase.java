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
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@Entity
@Table(name = "Fase")
@NoArgsConstructor
public class Fase {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id_fase")
	private Long idFase;

	@Column(name = "nom", nullable = false)
	private String nom;

	@OneToMany(mappedBy = "laFase", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
	@ToString.Exclude
	private List<Partit> elsPartits = new ArrayList<>();

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Fase other = (Fase) obj;
		if (idFase == null) {
			if (other.idFase != null)
				return false;
		} else if (!idFase.equals(other.idFase))
			return false;
		return true;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((idFase == null) ? 0 : idFase.hashCode());
		return result;
	}
}
