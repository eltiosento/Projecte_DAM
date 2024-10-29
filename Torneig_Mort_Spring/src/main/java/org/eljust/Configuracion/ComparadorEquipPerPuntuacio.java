package org.eljust.Configuracion;

import java.util.Comparator;

import org.eljust.Model.Equip;

public class ComparadorEquipPerPuntuacio implements Comparator<Equip> {

	@Override
	public int compare(Equip equip1, Equip equip2) {

		// Primer, comparem per punts de major a menor
		int resultatComparacio = Integer.compare(equip2.getPunts(), equip1.getPunts());
		if (resultatComparacio != 0) {
			// Si no son iguals, resultatComparacio donara un resultat distint de 0, pertant
			// retornm el resultat d'esta comparació
			return resultatComparacio;
		}
		// Si els punts son iguals, comparem els punts en contra de menor a major
		return Integer.compare(equip1.getPuntsContra(), equip2.getPuntsContra());
	}

}
