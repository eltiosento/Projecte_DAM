package org.eljust.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

import org.eljust.Configuracion.ComparadorEquipPerPuntuacio;
import org.eljust.Configuracion.ComparadorGrupPerId;
import org.eljust.Configuracion.ComparadorPartitPerData;
import org.eljust.DTO.GrupPartitDTO;
import org.eljust.DTO.PartitDTO;
import org.eljust.DTO.PartitModificatDTO;
import org.eljust.DTO.Converter.GrupPartitDTOConverter;
import org.eljust.DTO.Converter.PartitDTOConverter;
import org.eljust.DTO.Converter.PartitModificatDTOCOnverter;
import org.eljust.Error.FaseNotFoundException;
import org.eljust.Error.PartitNotFoundException;
import org.eljust.Error.TemporadaNotFoundException;
import org.eljust.Model.Equip;
import org.eljust.Model.Fase;
import org.eljust.Model.Grup;
import org.eljust.Model.Partit;
import org.eljust.Model.Temporada;
import org.eljust.Repository.FaseRepository;
import org.eljust.Repository.GrupRepository;
import org.eljust.Repository.PartitRepository;
import org.eljust.Repository.TemporadaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
public class ParitServiceImp implements PartitService {

	@Autowired
	private PartitRepository partitRepository;

	@Autowired
	private PartitDTOConverter partitDTOConverter;

	@Autowired
	private PartitModificatDTOCOnverter partitModificatDTOConverter;

	@Autowired
	private GrupPartitDTOConverter grupPartitDTOConverter;

	@Autowired
	private TemporadaRepository temporadaRepository;

	@Autowired
	private FaseRepository faseRepository;

	@Autowired
	private GrupRepository grupRepository;

	// Aquest mètode no te massa sentit ja que listPartitsTemporadaFase tenim
	// comtemplat el cas de pasar el idFase amb 0 ens trua tots els partits d'una
	// temporada.
	@Override
	public List<PartitDTO> listAllPartits(Long idTemporada) {

		@SuppressWarnings("unused")
		Temporada temporada = temporadaRepository.findById(idTemporada)
				.orElseThrow(() -> new TemporadaNotFoundException(idTemporada));

		List<Partit> elsPartits = partitRepository.findPartitsPerTemporadaId(idTemporada);

		if (elsPartits.isEmpty())
			throw new PartitNotFoundException();

		Collections.sort(elsPartits, new ComparadorPartitPerData());

		List<PartitDTO> elsPartitsDTO = elsPartits.stream().map(partitDTOConverter::convertToDTO)
				.collect(Collectors.toList());

		return elsPartitsDTO;
	}

	@Override
	public List<PartitDTO> listPartitsTemporadaFase(Long idTemporada, Long idFase) {

		@SuppressWarnings("unused")
		Temporada temporada = temporadaRepository.findById(idTemporada)
				.orElseThrow(() -> new TemporadaNotFoundException(idTemporada));

		if (idFase == 0) {
			List<Partit> elsPartits = partitRepository.findPartitsPerTemporadaId(idTemporada);

			if (elsPartits.isEmpty())
				throw new PartitNotFoundException();

			Collections.sort(elsPartits, new ComparadorPartitPerData());

			List<PartitDTO> elsPartitsDTO = elsPartits.stream().map(partitDTOConverter::convertToDTO)
					.collect(Collectors.toList());

			return elsPartitsDTO;
		} else {
			@SuppressWarnings("unused")
			Fase fase = faseRepository.findById(idFase).orElseThrow(() -> new FaseNotFoundException(idFase));

			List<Partit> elsPartits = partitRepository.findPartitsPerTemporadaIdFaseId(idTemporada, idFase);

			if (elsPartits.isEmpty())
				throw new PartitNotFoundException("No hi han enfrontaments de la temporada " + idTemporada
						+ " corresponents a la fase " + idFase + ".");

			Collections.sort(elsPartits, new ComparadorPartitPerData());

			List<PartitDTO> elsPartitsDTO = elsPartits.stream().map(partitDTOConverter::convertToDTO)
					.collect(Collectors.toList());

			return elsPartitsDTO;
		}

	}

	@Override
	public List<GrupPartitDTO> listPartitsFaseGrups(Long idTemporada) {

		@SuppressWarnings("unused")
		Temporada temporada = temporadaRepository.findById(idTemporada)
				.orElseThrow(() -> new TemporadaNotFoundException(idTemporada));

		List<Grup> elsGrups = grupRepository.findGrupsByIdTemporada(idTemporada);

		if (elsGrups.isEmpty()) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND,
					"Encara no s'ha realitzat el concurs per a la fase de grups de la temporada " + idTemporada
							+ ", per tant, els grups no tenen equips.");
		} else {
			// Ordenem per id perque al insertar una Temporada nova es creen els grups
			// automaticament amb el trigger i com el mètode per a obtindre els grups per
			// temporada agafa equips, ens reetorna un orde que no concorda amb A,B,C,D
			Collections.sort(elsGrups, new ComparadorGrupPerId());

			List<GrupPartitDTO> elsGrupsPartitDTO = elsGrups.stream().map(grupPartitDTOConverter::convertToDTO)
					.collect(Collectors.toList());

			// Afegim a cada grup el llistat de partits que li correspon.
			for (GrupPartitDTO grup : elsGrupsPartitDTO) {

				List<Partit> elsPartits = partitRepository.findPartitsPerGrupId(grup.getIdGrup(), (long) 1);

				// Ordenem els partits per la data que s'han jugat, del més nou al més vell.
				Collections.sort(elsPartits, new ComparadorPartitPerData());

				List<PartitDTO> elsPartitsDTO = elsPartits.stream().map(partitDTOConverter::convertToDTO)
						.collect(Collectors.toList());
				grup.setElsPartits(elsPartitsDTO);

			}

			return elsGrupsPartitDTO;
		}
	}

	@Override
	public PartitModificatDTO updatePartit(Long id, PartitModificatDTO partitModificatDTO) {

		Partit partit = partitRepository.findById(id).orElseThrow(() -> new PartitNotFoundException(id));

		partit.setDataPartit(partitModificatDTO.getDataPartit());
		partit.setResultatLocal(partitModificatDTO.getResultatLocal());
		partit.setResultatVisitant(partitModificatDTO.getResultatVisitant());
		partit.setPartitJugat(partitModificatDTO.isPartitJugat());

		partitRepository.save(partit);

		return partitModificatDTOConverter.convertToDTO(partit);
	}

	@Override
	public void crearPartitsFaseGrups(Long idTemporada) {

		@SuppressWarnings("unused")
		Temporada temporada = temporadaRepository.findById(idTemporada)
				.orElseThrow(() -> new TemporadaNotFoundException(idTemporada));

		List<Partit> elsPartitsFaseGrup = partitRepository.findPartitsPerTemporadaIdFaseId(idTemporada, (long) 1);

		if (!elsPartitsFaseGrup.isEmpty())
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
					"Ja has realitzat el sorteig de la fase de grups");

		Fase laFase = faseRepository.findById((long) 1).orElseThrow(() -> new FaseNotFoundException((long) 1));
		List<Grup> elsGrups = grupRepository.findGrupsByIdTemporada(idTemporada);

		if (elsGrups.isEmpty())
			throw new ResponseStatusException(HttpStatus.NOT_FOUND,
					"Encara no s'ha realitzat la fase grups i pertant no es poden formar els enfontaments.");

		Random random = new Random();

		for (Grup grup : elsGrups) {

			List<Equip> elsEquips = grup.getElsEquips();

			// Verificar que hi ha almenys 2 equips en el grup.
			if (elsEquips.size() < 2) {
				continue;
			}

			for (int i = 0; i < elsEquips.size(); i++) {

				for (int j = i + 1; j < elsEquips.size(); j++) {

					Equip equip1 = grup.getElsEquips().get(i);
					Equip equip2 = grup.getElsEquips().get(j);

					// Evitar que el mateix equip s'enfronte a si mateix
					if (equip1.getIdEquip().equals(equip2.getIdEquip())) {
						continue;
					}

					Partit partit = new Partit();

					// Posem aleatoriament qui es local i visitant. Depenent de si nextBoolean()
					// torna true o false.
					if (random.nextBoolean()) {
						partit.setEquipLocal(equip1);
						partit.setEquipVisitant(equip2);
					} else {
						partit.setEquipLocal(equip2);
						partit.setEquipVisitant(equip1);
					}

					partit.setLaFase(laFase);

					partitRepository.save(partit);

				}

			}

		}

	}

	@Override
	public void crearPartitsOctaus(Long idTemporada) {

		@SuppressWarnings("unused")
		Temporada temporada = temporadaRepository.findById(idTemporada)
				.orElseThrow(() -> new TemporadaNotFoundException(idTemporada));

		List<Partit> elsPartitsOctaus = partitRepository.findPartitsPerTemporadaIdFaseId(idTemporada, (long) 2);

		List<Partit> elsPartitsFaseGrup = partitRepository.findPartitsPerTemporadaIdFaseId(idTemporada, (long) 1);

		if (elsPartitsFaseGrup.isEmpty())
			throw new ResponseStatusException(HttpStatus.NOT_FOUND,
					"Encara no s'han realitzat els partits de la fase de grups.");

		if (!elsPartitsOctaus.isEmpty())
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
					"Ja has realitzat el sorteig de la fase d'Octaus");

		// Creem llistes d'equis segons han quedat en la fase de grups,
		// primers,segons,etc
		List<Equip> equipsClasificats1 = new ArrayList<>();
		List<Equip> equipsClasificats2 = new ArrayList<>();
		List<Equip> equipsClasificats3 = new ArrayList<>();
		List<Equip> equipsClasificats4 = new ArrayList<>();

		// Busquem la fase d'Octaus
		Fase laFase = faseRepository.findById((long) 2).orElseThrow(() -> new FaseNotFoundException((long) 2));

		// Recuperem els grups de la temporada
		List<Grup> elsGrups = grupRepository.findGrupsByIdTemporada(idTemporada);

		// Si quests grups no tene equips, llancem l'excepció
		if (elsGrups.isEmpty())
			throw new ResponseStatusException(HttpStatus.NOT_FOUND,
					"Encara no s'ha realitzat la fase grups i pertant no es poden formar els enfontaments.");

		// Recopilem els millors equips de cada grup en llistes separades
		for (Grup grup : elsGrups) {

			List<Equip> elsEquips = grup.getElsEquips();
			Collections.sort(elsEquips, new ComparadorEquipPerPuntuacio());
			equipsClasificats1.add(elsEquips.get(0));
			equipsClasificats2.add(elsEquips.get(1));
			equipsClasificats3.add(elsEquips.get(2));
			equipsClasificats4.add(elsEquips.get(3));

		}
		// Barregem les llistes d'equips classificats per fer els enfrentaments
		// aleatoris
		Collections.shuffle(equipsClasificats1);
		Collections.shuffle(equipsClasificats2);
		Collections.shuffle(equipsClasificats3);
		Collections.shuffle(equipsClasificats4);

		// Creem y guardem els enfrentaments d'octaus de final
		for (int i = 0; i < equipsClasificats1.size(); i++) {
			Equip equip1 = equipsClasificats1.get(i);
			Equip equip2 = equipsClasificats2.get(i);
			Equip equip3 = equipsClasificats3.get(i);
			Equip equip4 = equipsClasificats4.get(i);

			// Creem els enfrentaments entre els primers y segons equips de cada grup
			crearEnfrontaments(equip1, equip4, laFase);

			// Creem els enfrentaments entre els tercers y cuarts equips de cada grup
			crearEnfrontaments(equip2, equip3, laFase);
		}

	}

	@Override
	public void crearPartitsDirectesQuarts(Long idTemporada) {
		@SuppressWarnings("unused")
		Temporada temporada = temporadaRepository.findById(idTemporada)
				.orElseThrow(() -> new TemporadaNotFoundException(idTemporada));

		List<Partit> elsPartitsFaseGrup = partitRepository.findPartitsPerTemporadaIdFaseId(idTemporada, (long) 1);

		List<Partit> elsPartitsQuarts = partitRepository.findPartitsPerTemporadaIdFaseId(idTemporada, (long) 3);

		if (elsPartitsFaseGrup.isEmpty())
			throw new ResponseStatusException(HttpStatus.NOT_FOUND,
					"Encara no s'han realitzat els partits de la fase de grups.");

		if (!elsPartitsQuarts.isEmpty())
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
					"Ja has realitzat el sorteig de la fase de Quarts.");

		// Creem llistes d'equis segons han quedat en la fase de grups,
		// primers,segons,etc
		List<Equip> equipsClasificats1 = new ArrayList<>();
		List<Equip> equipsClasificats2 = new ArrayList<>();

		// Busquem la fase de Quarts
		Fase laFase = faseRepository.findById((long) 3).orElseThrow(() -> new FaseNotFoundException((long) 3));

		// Recuperem els grups de la temporada
		List<Grup> elsGrups = grupRepository.findGrupsByIdTemporada(idTemporada);

		// Si quests grups no tene equips, llancem l'excepció
		if (elsGrups.isEmpty())
			throw new ResponseStatusException(HttpStatus.NOT_FOUND,
					"Encara no s'ha realitzat la fase grups i pertant no es poden formar els enfontaments.");

		// Si ordenem els grups, podem fer els enfrontaments com ens ha dit Pilar. 1A vs
		// 2B, 1C vs 2D.....etc

		Collections.sort(elsGrups, new ComparadorGrupPerId());

		// Recopilem els millors equips de cada grup en llistes separades
		for (Grup grup : elsGrups) {

			List<Equip> elsEquips = grup.getElsEquips();
			Collections.sort(elsEquips, new ComparadorEquipPerPuntuacio());
			equipsClasificats1.add(elsEquips.get(0));
			equipsClasificats2.add(elsEquips.get(1));

		}

		// Recollim els equips i després els enfrentem:

		Equip equip1A = equipsClasificats1.get(0);
		Equip equip1B = equipsClasificats1.get(1);
		Equip equip1C = equipsClasificats1.get(2);
		Equip equip1D = equipsClasificats1.get(3);
		Equip equip2A = equipsClasificats2.get(0);
		Equip equip2B = equipsClasificats2.get(1);
		Equip equip2C = equipsClasificats2.get(2);
		Equip equip2D = equipsClasificats2.get(3);

		crearEnfrontaments(equip1A, equip2B, laFase);
		crearEnfrontaments(equip2D, equip1C, laFase);
		crearEnfrontaments(equip1B, equip2A, laFase);
		crearEnfrontaments(equip2C, equip1D, laFase);

	}

	@Override
	public void crearPartitsEliminatoris(Long idTemporada, Long idFase) {
		// AQUEST METODE FUNCIONA SI ACÍ APLEGEUN 16 EQUIPS, ES A DIR HAN DE PASSAR 4
		// EQUIPS DE CADA GRUP!!

		@SuppressWarnings("unused")
		Temporada temporada = temporadaRepository.findById(idTemporada)
				.orElseThrow(() -> new TemporadaNotFoundException(idTemporada));
		Fase laFase = faseRepository.findById(idFase).orElseThrow(() -> new FaseNotFoundException(idFase));

		List<Partit> partitsFaseActual = partitRepository.findPartitsPerTemporadaIdFaseId(idTemporada, idFase);

		if (idFase != 3 && idFase != 4 && idFase != 5)
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Aquesta Fase no correspon amb aquest sorteig!");

		if (!partitsFaseActual.isEmpty())
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Ja has realitzat el sorteig d'aqueta fase.");

		// Creem un index per poder posar el tope de jugadors que passen a la següent
		// ronda.
		String misatgeError = "";
		int equipsCorresponentsFase = 0;
		if (idFase == 3) {
			equipsCorresponentsFase = 8;
			misatgeError = "d'octaus de final.";
		}
		if (idFase == 4) {
			equipsCorresponentsFase = 4;
			misatgeError = "de quarts de final.";
		}

		if (idFase == 5) {
			equipsCorresponentsFase = 2;
			misatgeError = "de semifinals.";
		}

		// Obtenim els partits de la fase anterior
		List<Partit> partitsFaseAnterior = partitRepository.findPartitsPerTemporadaIdFaseId(idTemporada,
				(long) idFase - 1);

		// Verifiquem que hi han els equips suficients per a la fase que volem
		// crear (quarts,semis o final)
		if (partitsFaseAnterior.size() < equipsCorresponentsFase) {
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
					"No has ceat els partits pertinents a la fase " + misatgeError);
		}

		// Calculem els equips guanyadors de la fase d'octaus.
		List<Equip> equipsGuanyadorsFaseAnterior = new ArrayList<>();
		for (Partit partit : partitsFaseAnterior) {

			Equip equipGuanyador = (partit.getResultatLocal() > partit.getResultatVisitant()) ? partit.getEquipLocal()
					: partit.getEquipVisitant();

			equipsGuanyadorsFaseAnterior.add(equipGuanyador);
		}

		// Creem els partits de quarts de final
		for (int i = 0; i < equipsCorresponentsFase; i += 2) {
			Equip equip1 = equipsGuanyadorsFaseAnterior.get(i);
			Equip equip2 = equipsGuanyadorsFaseAnterior.get(i + 1);
			crearEnfrontaments(equip1, equip2, laFase);
		}

	}

	@Override
	public boolean deletePartitsFase(Long idTemporada, Long idFase) {

		Temporada temporada = temporadaRepository.findById(idTemporada).orElse(null);

		if (temporada == null)
			throw new TemporadaNotFoundException(idTemporada);

		List<Partit> elsPartits = partitRepository.findPartitsPerTemporadaIdFaseId(idTemporada, idFase);

		if (!elsPartits.isEmpty()) {

			for (Partit partit : elsPartits) {
				partitRepository.deleteByIdCustom(partit.getIdPartit());
			}
			return true;
		} else {
			return false;
		}

	}

	private void crearEnfrontaments(Equip equip1, Equip equip2, Fase laFase) {
		Partit partit = new Partit();
		partit.setEquipLocal(equip1);
		partit.setEquipVisitant(equip2);
		partit.setLaFase(laFase);
		partitRepository.save(partit);
	}

}
