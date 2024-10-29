package org.eljust.Service;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

import org.eljust.Configuracion.ComparadorGrupPerId;
import org.eljust.Configuracion.ComparadorPartitPerData;
import org.eljust.DTO.EquipGrupDTO;
import org.eljust.DTO.GrupDTO;
import org.eljust.DTO.GrupEquipDTO;
import org.eljust.DTO.PartitDTO;
import org.eljust.DTO.Converter.GrupDTOConverter;
import org.eljust.DTO.Converter.GrupEquipDTOConverter;
import org.eljust.DTO.Converter.PartitDTOConverter;
import org.eljust.Error.GrupNotFoundException;
import org.eljust.Error.TemporadaNotFoundException;
import org.eljust.Model.Equip;
import org.eljust.Model.Grup;
import org.eljust.Model.Partit;
import org.eljust.Model.Temporada;
import org.eljust.Repository.EquipRepository;
import org.eljust.Repository.GrupRepository;
import org.eljust.Repository.PartitRepository;
import org.eljust.Repository.TemporadaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
public class GrupServiceImp implements GrupService {

	@Autowired
	private GrupRepository grupRespository;

	@Autowired
	private GrupDTOConverter grupDTOConverter;

	@Autowired
	private GrupEquipDTOConverter grupEquipDTOConverter;

	@Autowired
	private EquipRepository equipRepository;

	@Autowired
	private PartitRepository partitRepository;

	@Autowired
	private PartitDTOConverter partitDTOConverter;

	@Autowired
	private TemporadaRepository temporadaRepository;

	@Override
	public GrupDTO getGrupById(Long id) {

		// Busquem el grup per id
		Grup grup = grupRespository.findById(id).orElseThrow(() -> new GrupNotFoundException(id));

		// Busquem els partits que pertanyen a la fase de grups((long) 1) y que siguen
		// del grup que busquem.
		List<Partit> elsPartits = partitRepository.findPartitsPerGrupId(id, (long) 1);

		// Ordenem els partits per la data que s'han jugat, del més nou al més vell.
		Collections.sort(elsPartits, new ComparadorPartitPerData());

		// Pasem els partits a un DTO
		List<PartitDTO> elsPartitsDTO = elsPartits.stream().map(partitDTOConverter::convertToDTO)
				.collect(Collectors.toList());

		// Pasem el grup a un DTO
		GrupDTO grupDTO = grupDTOConverter.convertToDTO(grup);

		// Afegim la quantitat de partits jugats als equips de cada grup
		for (EquipGrupDTO equip : grupDTO.getElsEquipsGrups()) {
			equip.setPartitsJugats(partitRepository.contarPartitsJugatsPerEquipFaseGrups(equip.getIdEquip()));
			equip.setPartitsGuanyats(partitRepository.contarPartitsGuanyatsPerEquipFaseGrups(equip.getIdEquip()));
			equip.setPartitsPerduts(partitRepository.contarPartitsPerdutsPerEquipFaseGrups(equip.getIdEquip()));
			equip.setPartitsEmpatats(equip.getPartitsJugats()-equip.getPartitsGuanyats()-equip.getPartitsPerduts());
		}

		// Afegim al grupDTO els partitsDTO
		grupDTO.setElsPartits(elsPartitsDTO);

		return grupDTO;
	}

	@Override
	public List<GrupEquipDTO> listGrupsEquipsDTOByIdTemporada(Long id) {
		@SuppressWarnings("unused")
		Temporada temporada = temporadaRepository.findById(id).orElseThrow(() -> new TemporadaNotFoundException(id));

		List<Grup> elsGrups = grupRespository.findGrupsByIdTemporada(id);

		if (elsGrups.isEmpty()) {
			throw new ResponseStatusException(HttpStatus.NOT_FOUND,
					"Encara no s'ha realitzat el concurs per a la fase de grups de la temporada " + id
							+ ", per tant, els grups no tenen equips.");
		} else {
			// Ordenem per id perque al insertar una Temporada nova es creen els grups
			// automaticament amb el trigger i com el mètode per a obtindre els grups per
			// temporada agafa equips, ens reetorna un orde que no concorda amb A,B,C,D
			Collections.sort(elsGrups, new ComparadorGrupPerId());

			List<GrupEquipDTO> elsGrupsEquipsDTO = elsGrups.stream().map(grupEquipDTOConverter::convertToDTO)
					.collect(Collectors.toList());

			// Afegim la quantitat de partits jugats a cada equip d'un grup:
			// Primer for, extraguem un grup de la llista de grups i amb ell obtinguem la
			// llista d'equips
			// Segon for, per cada equip de la llista d'equips, li afegim la cuantitat de
			// partits mitjançant la consulta del repository
			for (GrupEquipDTO grup : elsGrupsEquipsDTO) {
				for (EquipGrupDTO equip : grup.getElsEquipsGrups()) {
					equip.setPartitsJugats(partitRepository.contarPartitsJugatsPerEquipFaseGrups(equip.getIdEquip()));
					equip.setPartitsGuanyats(partitRepository.contarPartitsGuanyatsPerEquipFaseGrups(equip.getIdEquip()));
					equip.setPartitsPerduts(partitRepository.contarPartitsPerdutsPerEquipFaseGrups(equip.getIdEquip()));
					equip.setPartitsEmpatats(equip.getPartitsJugats()-equip.getPartitsGuanyats()-equip.getPartitsPerduts());
				}
			}

			return elsGrupsEquipsDTO;
		}

	}

	@Override
	public void sorteigFaseGrups(Long idTemporada) {

		@SuppressWarnings("unused")
		Temporada temporada = temporadaRepository.findById(idTemporada)
				.orElseThrow(() -> new TemporadaNotFoundException(idTemporada));

		// Obtenim els grups sense equipos.
		List<Grup> elsGrups = grupRespository.findGrupsSenseEquips();

		// Obtenim els equips d'una temporada determinada.
		List<Equip> elsEquips = equipRepository.findByTemporadaId(idTemporada);

		// Verifiquem almenys haja un grup i un equip disponible.
		if (elsGrups.isEmpty() || elsEquips.isEmpty()) {

			throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
					"En aquesta temporada ja s'ha realitzat el sorteig o encara no has creat els equips per a fer el sorteig.");
		}

		// Calculem el número d'equipos per grup.
		int equipsPerGrup = elsEquips.size() / elsGrups.size();

		// Condicionem a que el repartiment siga exacte, equitatiu.
		if (elsEquips.size() % elsGrups.size() != 0)
			throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
					"La quantitat d'equips per a fer la fase de grups no és equitativa, has de tindre un nombre d'equips divisible entre 4 i ara tens "
							+ elsEquips.size() + " equips.");

		// Barregem la llista per fer-la aleatoria.
		Collections.shuffle(elsEquips);

		// Índex per a recorrer la llista dels equips
		int indexLlistaEquips = 0;

		// Asignem els equips al grup i viceversa.
		for (Grup grup : elsGrups) {
			for (int i = 0; i < equipsPerGrup && indexLlistaEquips < elsEquips.size(); i++) {
				Equip equipo = elsEquips.get(indexLlistaEquips);
				equipo.setElGrup(grup);
				// grup.getElsEquips().add(equipo);
				indexLlistaEquips++;
			}
		}

		equipRepository.saveAll(elsEquips);
	}

	@Override
	public boolean buidarEquipsGrups(Long idTemporada) {

		@SuppressWarnings("unused")
		Temporada temporada = temporadaRepository.findById(idTemporada)
				.orElseThrow(() -> new TemporadaNotFoundException(idTemporada));

		List<Grup> elsGrups = grupRespository.findGrupsByIdTemporada(idTemporada);

		if (!elsGrups.isEmpty()) {
			for (Grup grup : elsGrups) {
				for (Equip equip : grup.getElsEquips()) {
					equip.setElGrup(null);
					equipRepository.save(equip);
				}
			}
			return true;

		} else {
			return false;
		}

	}

}
