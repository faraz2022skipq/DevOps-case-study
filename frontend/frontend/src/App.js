import React, { useState } from "react";

function App() {
  const [healthStatus, setHealthStatus] = useState("");
  const [items, setItems] = useState([]);

  // const backendBaseUrl = "http://54.219.246.102";
  const backendBaseUrl = process.env.REACT_APP_API_BASE;
  console.log("REACT_APP_API_BASE =", process.env.REACT_APP_API_BASE);
  console.log("REACT_APP_API_BASE =", backendBaseUrl);


  // Check health
  const checkHealth = async () => {
    try {
      const res = await fetch(`http://54.193.80.240/healthz`);
      const data = await res.text();
      setHealthStatus(data);
    } catch (err) {
      setHealthStatus("Error connecting to backend");
    }
  };

  // Get items from RDS via backend
  const getItems = async () => {
    try {
      const res = await fetch(`http://54.193.80.240/api/items/`);
      const data = await res.json();
      setItems(data);
    } catch (err) {
      setItems([{ id: 0, name: "Error fetching items" }]);
    }
  };

  return (
    <div style={{ padding: "20px", fontFamily: "Arial" }}>
      <h1>React SPA Example</h1>

      <button onClick={checkHealth} style={{ marginRight: "10px" }}>
        Check Health
      </button>
      <span>{healthStatus}</span>

      <hr />

      <button onClick={getItems}>Get Items</button>
      <span>{setItems}</span>
      {/* <ul>
        {items.map((item) => (
          <li key={item.id}>{item.name}</li>
        ))}
      </ul> */}
    </div>
  );
}

export default App;
