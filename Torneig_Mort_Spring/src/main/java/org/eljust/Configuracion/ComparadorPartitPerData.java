package org.eljust.Configuracion;

import java.util.Comparator;
import java.util.Date;

import org.eljust.Model.Partit;

public class ComparadorPartitPerData implements Comparator<Partit> {

	@Override
	public int compare(Partit partit1, Partit partit2) {
		Date dataPartit1 = partit1.getDataPartit();
		Date dataPartit2 = partit2.getDataPartit();

		// Si ambdues fexes son nules, son iguals
		if (dataPartit1 == null && dataPartit2 == null) {
			return 0;
		}
		// Si sols una de las fexes es nula, la que no es nula va primer
		else if (dataPartit1 == null) {
			return 1;
		} else if (dataPartit2 == null) {
			return -1;
		}
		// Si ninguna es nula, comparem les fexes normalment, de la mes nova al la mes
		// vella, pel contrari posariem: dataPartit1.compareTo(dataPartit2);
		else {
			return dataPartit2.compareTo(dataPartit1);
		}
	}

}
