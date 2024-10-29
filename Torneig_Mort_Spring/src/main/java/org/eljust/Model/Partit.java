package org.eljust.Model;

import java.sql.Date;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@NoArgsConstructor
@Entity
@Table(name = "Partit")
public class Partit {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id_partit")
	private Long idPartit;

	@Column(name = "data_partit")
	private Date dataPartit;

	@Column(name = "partit_jugat", columnDefinition = "boolean default false")
	private boolean partitJugat;

	@Column(name = "resultat_local", columnDefinition = "int default 0")
	private int resultatLocal;

	@Column(name = "resultat_visitant", columnDefinition = "int default 0")
	private int resultatVisitant;

	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "id_fase", foreignKey = @ForeignKey(name = "FK_Partit_Fase"))
	@ToString.Exclude
	private Fase laFase;

	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "id_equip_local", nullable = false, foreignKey = @ForeignKey(name = "FK_Partit_EquipLocal"))
	@ToString.Exclude
	private Equip equipLocal;

	@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name = "id_equip_visitant", nullable = false, foreignKey = @ForeignKey(name = "FK_Partit_EquipVisitant"))
	@ToString.Exclude
	private Equip equipVisitant;

}
