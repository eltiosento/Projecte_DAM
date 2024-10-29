package org.eljust.Configuracion;

import java.util.Comparator;

import org.eljust.Model.Grup;

public class ComparadorGrupPerId implements Comparator<Grup> {

	@Override
	public int compare(Grup grup1, Grup grup2) {

		return Long.compare(grup1.getIdGrup(), grup2.getIdGrup());
	}

}
