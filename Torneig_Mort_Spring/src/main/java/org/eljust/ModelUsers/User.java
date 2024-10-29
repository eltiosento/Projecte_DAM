package org.eljust.ModelUsers;

import java.util.Collection;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "Users", uniqueConstraints = @UniqueConstraint(columnNames = "username"))
public class User implements UserDetails {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "id_usuari")
	private Long idUsuari;

	@NotBlank
	@Size(max = 20)
	@Column(name = "username")
	private String username;

	@NotBlank
	@Size(max = 120)
	@Column(name = "password")
	private String password;

	@ManyToMany(fetch = FetchType.EAGER)
	@JoinTable(name = "User_Roles", joinColumns = @JoinColumn(name = "id_usuari"), inverseJoinColumns = @JoinColumn(name = "id_rol"))
	private Set<Role> roles;

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {

		return roles.stream().map(role -> new SimpleGrantedAuthority(role.getName().name()))
				.collect(Collectors.toList());
		// role.getName(): Esto devuelve el enum UserRole (por ejemplo, UserRole.USER)
		// .name(): Esto convierte el enum UserRole a su representación en cadena de
		// texto (por ejemplo, "USER").
		// new SimpleGrantedAuthority("ROLE_" + role.getName().name()): Crea una nueva
		// autoridad (GrantedAuthority) con el formato ROLE_ seguido del nombre del rol
		// (por ejemplo, ROLE_USER).
	}

	@Override
	public boolean isAccountNonExpired() {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isAccountNonLocked() {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		// TODO Auto-generated method stub
		return true;
	}

	@Override
	public boolean isEnabled() {
		// TODO Auto-generated method stub
		return true;
	}

	// Este método es un constructor estático que crea una nueva instancia de User a
	// partir de otra instancia de User. Es una técnica común para construir objetos
	// de manera fluida y evitar constructores largos y confusos.
	public static User build(User user) {
		return User.builder().idUsuari(user.getIdUsuari()).username(user.getUsername()).password(user.getPassword())
				.roles(user.getRoles()).build();
	}

	public List<String> getRoleNames() {
		return this.roles.stream().map(role -> role.getName().name()).collect(Collectors.toList());
	}

}