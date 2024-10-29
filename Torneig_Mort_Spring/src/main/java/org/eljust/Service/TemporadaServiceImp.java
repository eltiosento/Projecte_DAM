package org.eljust.Service;

import java.util.List;
import java.util.stream.Collectors;

import org.eljust.DTO.TemporadaDTO;
import org.eljust.DTO.Converter.TemporadaDTOConverter;
import org.eljust.Error.TemporadaNotFoundException;
import org.eljust.Model.Grup;
import org.eljust.Model.Temporada;
import org.eljust.Repository.GrupRepository;
import org.eljust.Repository.TemporadaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TemporadaServiceImp implements TemporadaService {

	@Autowired
	private TemporadaRepository temporadaRepository;

	@Autowired
	private GrupRepository grupRespository;

	@Autowired
	private TemporadaDTOConverter temporadaDTOConverter;

	@Override
	public List<TemporadaDTO> listAllTemporades() {

		List<Temporada> lesTemporades = temporadaRepository.findAll();

		if (lesTemporades.isEmpty())
			throw new TemporadaNotFoundException();

		List<TemporadaDTO> lesTemporadesDTO = lesTemporades.stream().map(temporadaDTOConverter::convertToDTO)
				.collect(Collectors.toList());

		return lesTemporadesDTO;
	}

	@Override
	public TemporadaDTO getTemporadaById(Long id) {

		Temporada temporada = temporadaRepository.findById(id).orElseThrow(() -> new TemporadaNotFoundException(id));

		TemporadaDTO temporadaDTO = temporadaDTOConverter.convertToDTO(temporada);

		return temporadaDTO;
	}

	@Override
	public TemporadaDTO saveTemporada(TemporadaDTO temporadaDTO) {

		Temporada temporada = temporadaDTOConverter.convertToModel(temporadaDTO);
		Temporada temporadaSaved = temporadaRepository.save(temporada);

		return temporadaDTOConverter.convertToDTO(temporadaSaved);
	}

	@Override
	public TemporadaDTO updateTemporada(Long id, TemporadaDTO temporadaDTO) {

		Temporada temporada = temporadaRepository.findById(id).orElseThrow(() -> new TemporadaNotFoundException(id));

		temporada.setNom(temporadaDTO.getNom());
		temporadaRepository.save(temporada);

		return temporadaDTOConverter.convertToDTO(temporada);
	}

	@Override
	public boolean deleteTemporada(Long id) {

		if (temporadaRepository.existsById(id)) {

			// Aci ja estem borrant els equips que pertanyen a la temporada
			temporadaRepository.deleteByIdCustom(id);

			// Per tant els grups es queden buits d'equips i eliminem eixos grups
			List<Grup> elsGrups = grupRespository.findAll();

			for (Grup grup : elsGrups) {
				if (grup.getElsEquips().isEmpty()) {
					grupRespository.delete(grup);
				}
			}

			return true;
		} else {
			return false;
		}

	}

}
