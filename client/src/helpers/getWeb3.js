import Web3 from "web3";

const getWeb3 = () =>
  new Promise((resolve, reject) => {
    // Wait for loading completion to avoid race conditions with web3 injection timing.
    window.addEventListener("load", async () => {
      try {
        // Modern dapp browsers...
        if (window.ethereum) {
          const web3 = new Web3(window.ethereum);
          try {
            // Request account access if needed
            await window.ethereum.request({ method: 'eth_requestAccounts' }); // Updated to use the new API
            // Accounts now exposed
            resolve(web3);
          } catch (error) {
            reject(error);
          }
        }
        // Legacy dapp browsers...
        else if (window.web3) {
          // Use Mist/MetaMask's provider.
          const web3 = new Web3(window.web3.currentProvider);
          console.log("Injected web3 detected.");
          resolve(web3);
        }
        // Fallback to localhost; use dev console port by default...
        else {
          alert('Please try with another modern browser or install the MetaMask plugin');
          reject('Non-Ethereum browser detected. You should consider trying MetaMask!');
        }
      } catch (error) {
        console.error("An error occurred when trying to get web3:", error);
        reject(error);
      }
    });
  });

export default getWeb3;
