document.getElementById("convertBtn").addEventListener("click", async () => {
  const amount = parseFloat(document.getElementById("amountFrom").value);
  const from = document.getElementById("currencyFrom").value;
  const to = document.getElementById("currencyTo").value;

  if (isNaN(amount)) {
    alert("Please enter a valid amount.");
    return;
  }

  try {
    const res = await fetch(`http://localhost:5500/convert?from=${from}&to=${to}&amount=${amount}`);
    const data = await res.json();

    document.getElementById("amountTo").value = data.convertedAmount.toFixed(2);
    document.getElementById("resultText").innerText = `✅ ${amount} ${from} = ${data.convertedAmount.toFixed(2)} ${to}`;
  } catch (error) {
    document.getElementById("resultText").innerText = "❌ Failed to fetch conversion.";
  }
});
