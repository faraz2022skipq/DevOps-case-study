import React, { useState } from "react";

function App() {
  const [healthStatus, setHealthStatus] = useState("");
  const [items, setItems] = useState([]);

  const healthzEndpoint = `http://${process.env.REACT_APP_API_BASE}/healthz`;
  const itemsEndpoint = `http://${process.env.REACT_APP_API_BASE}/api/items`;

  // Check health
  const checkHealth = async () => {
    try {
      const res = await fetch(healthzEndpoint);
      const data = await res.text();
      setHealthStatus(data);
    } catch (err) {
      setHealthStatus("Error connecting to backend");
    }
  };

  // Get items from RDS via backend
  const getItems = async () => {
    try {
      const res = await fetch(itemsEndpoint);
      const data = await res.json();
      setItems(data.items);
    } catch (err) {
      setItems([{ id: 0, name: "Error fetching items" }]);
    }
  };

  // Render UI
  return (
    <div style={{ padding: "20px", fontFamily: "Arial" }}>
      <h1>DevOps Case Study SPA</h1>

      <button onClick={checkHealth} style={{ marginRight: "10px" }}>
        Check Health
      </button>
      <span>{healthStatus}</span>

      <hr />

      <button onClick={getItems}>Get Items</button>

      {items && items.length > 0 && (
        <table style={{
          marginTop: "20px",
          width: "100%",
          borderCollapse: "collapse",
          border: "1px solid #ddd"
        }}>
          <thead>
            <tr style={{ backgroundColor: "#f5f5f5" }}>
              <th style={{ padding: "12px", border: "1px solid #ddd", textAlign: "left" }}>ID</th>
              <th style={{ padding: "12px", border: "1px solid #ddd", textAlign: "left" }}>Name</th>
              <th style={{ padding: "12px", border: "1px solid #ddd", textAlign: "left" }}>Description</th>
            </tr>
          </thead>
          <tbody>
            {items.map((item) => (
              <tr key={item.id}>
                <td style={{ padding: "12px", border: "1px solid #ddd" }}>{item.id}</td>
                <td style={{ padding: "12px", border: "1px solid #ddd" }}>{item.name}</td>
                <td style={{ padding: "12px", border: "1px solid #ddd" }}>{item.description}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}

export default App;
