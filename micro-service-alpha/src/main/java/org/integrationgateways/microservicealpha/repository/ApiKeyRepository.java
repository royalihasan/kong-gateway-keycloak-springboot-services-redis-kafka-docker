package org.integrationgateways.microservicealpha.repository;

import org.integrationgateways.microservicealpha.entity.ApiKeyData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ApiKeyRepository extends JpaRepository<ApiKeyData, Integer> {

}
