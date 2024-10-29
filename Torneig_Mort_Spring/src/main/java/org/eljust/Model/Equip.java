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
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@Entity
@NoArgsConstructor
@Table(name = "Equip")
public class Equip {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id_equip")
	private Long idEquip;

	@Column(name = "nom", nullable = false)
	private String nom;

	@Column(name = "curs")
	private String curs;

	@Column(name = "imatge")
	private String imatge;
	
	
	@Column(name = "guanyador", columnDefinition = "boolean default false")
	private boolean esGuanyador;

	@Column(name = "punts", columnDefinition = "int default 0")
	private int punts;

	@Column(name = "punts_contra", columnDefinition = "int default 0")
	private int puntsContra;

	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "id_temporada", foreignKey = @ForeignKey(name = "FK_Equip_Temporada"))
	private Temporada laTemporada;

	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "id_grup", foreignKey = @ForeignKey(name = "FK_Equip_Grup"))
	private Grup elGrup;

	@ManyToMany(mappedBy = "elsEquips", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@ToString.Exclude
	private List<Jugador> elsJugadors = new ArrayList<>();

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Equip other = (Equip) obj;
		if (idEquip == null) {
			if (other.idEquip != null)
				return false;
		} else if (!idEquip.equals(other.idEquip))
			return false;
		return true;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((idEquip == null) ? 0 : idEquip.hashCode());
		return result;
	}
}
