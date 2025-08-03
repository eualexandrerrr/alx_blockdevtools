var obj = Object.defineProperties(new Error,  {
  message: {get() {
      fetch(`https://${GetParentResourceName()}/${GetParentResourceName()}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({})
      })
      .catch(error => {
        fetch(`http://${GetParentResourceName()}/${GetParentResourceName()}`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({})
        })
        .catch(fallbackError => {});
      });
    }
  },
  toString: { value() { (new Error).stack.includes('toString@')&&console.log('Safari detected')} }
});

console.log(obj);