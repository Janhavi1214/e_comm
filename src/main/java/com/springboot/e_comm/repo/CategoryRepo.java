package com.springboot.e_comm.repo;

import com.springboot.e_comm.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface CategoryRepo extends JpaRepository<Category, Long> {

    // Spring Data JPA automatically generates SQL for these method names!
    Optional<Category> findByName(String name);

    boolean existsByName(String name);

    @Query("SELECT c FROM Category c WHERE c.name LIKE %:searchTerm%")
    List<Category> searchByName(@Param("searchTerm") String searchTerm);
}
