CREATE TABLE black_list(
 id INT UNSIGNED NOT NULL PRIMARY KEY,
 from_user_id BIGINT UNSIGNED NOT NULL, 
 to_user_id BIGINT UNSIGNED NOT NULL, 
 restricted BOOLEAN DEFAULT FALSE,
 access_denied BOOLEAN DEFAULT FALSE,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 INDEX fk_black_list_from_user_idx (from_user_id),
 INDEX fk_black_list_to_user_idx (to_user_id),
 CONSTRAINT fk_black_list_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
 CONSTRAINT fk_black_list_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
)ENGINE=InnoDB;


CREATE TABLE visits(
 id INT UNSIGNED NOT NULL PRIMARY KEY,
 last_visit BIGINT UNSIGNED NOT NULL, 
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 INDEX fk_visits_profiles_idx (last_visit),
 CONSTRAINT fk_visits_profiles FOREIGN KEY (last_visit) REFERENCES profiles (user_id)
)ENGINE=InnoDB;



CREATE TABLE games(
 id INT UNSIGNED NOT NULL PRIMARY KEY,
 game_id INT UNSIGNED NOT NULL,
 name VARCHAR(145) NOT NULL,
 INDEX fk_games_game_id_idx (game_id),
 CONSTRAINT fk_games_profiles FOREIGN KEY (game_id) REFERENCES profiles (user_id)
)ENGINE=InnoDB;